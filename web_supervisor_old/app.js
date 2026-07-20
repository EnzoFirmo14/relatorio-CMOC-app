/**
 * CMOC — Painel do Supervisor
 * app.js — Firebase Firestore Real-time Dashboard
 *
 * Estrutura do documento Firestore (coleção: "reports"):
 * {
 *   uuid: string,
 *   status: "synced" | "pending" | "draft" | "error",
 *   syncedAt: Timestamp,
 *   createdAt: Timestamp,
 *   mineLocation: string,
 *   shift: string,          // ex: "A", "B", "C"
 *   team: string,
 *   equipment: string,
 *   horimeterStart: number,
 *   horimeterEnd: number,
 *   executors: [{ name: string, registration: string }],
 *   workOrders: [{
 *     number: string,
 *     location: string,
 *     startTime: string,
 *     endTime: string,
 *     description: string,
 *     materials: string,
 *     photos: [string]      // URLs (Firebase Storage) ou base64
 *   }]
 * }
 */

import { initializeApp }        from 'https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js';
import { getFirestore, collection, onSnapshot, query, orderBy, addDoc, serverTimestamp }
                                 from 'https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js';

/* ── Firebase config (projeto cmoc-relatorio) ────────────── */
const firebaseConfig = {
  apiKey:            'AIzaSyBkEzrbkGFq8jEutYvQvOd6nOST0Vh9siw',
  authDomain:        'cmoc-relatorio.firebaseapp.com',
  projectId:         'cmoc-relatorio',
  storageBucket:     'cmoc-relatorio.firebasestorage.app',
  messagingSenderId: '279433346974',
  appId:             '1:279433346974:android:fb05389a58d0d4f45ae08f',
};

const app = initializeApp(firebaseConfig);
const db  = getFirestore(app);

/* ── State ───────────────────────────────────────────────── */
let allReports       = [];
let filteredReports  = [];
let currentReport    = null;
let unsubscribe      = null;

/* ── DOM refs ────────────────────────────────────────────── */
const loadingState   = document.getElementById('loading-state');
const tableSection   = document.getElementById('table-section');
const emptyState     = document.getElementById('empty-state');
const tbody          = document.getElementById('reports-tbody');
const countBadge     = document.getElementById('count-badge');
const filterSearch   = document.getElementById('filter-search');
const filterTurno    = document.getElementById('filter-turno');
const filterData     = document.getElementById('filter-data');
const btnClear       = document.getElementById('btn-clear-filters');
const modalOverlay   = document.getElementById('modal-overlay');
const modalBody      = document.getElementById('modal-body');
const modalTitle     = document.getElementById('modal-title');
const modalMeta      = document.getElementById('modal-meta');
const modalCloseBtn  = document.getElementById('modal-close-btn');
const modalFootClose = document.getElementById('modal-footer-close');
const btnPrint       = document.getElementById('btn-print-modal');
const lightbox       = document.getElementById('lightbox');
const lightboxImg    = document.getElementById('lightbox-img');
const lightboxClose  = document.getElementById('lightbox-close');
const toastContainer = document.getElementById('toast-container');
const headerClock    = document.getElementById('header-clock');

/* ── Clock ───────────────────────────────────────────────── */
function updateClock() {
  const now = new Date();
  headerClock.textContent = now.toLocaleString('pt-BR', {
    weekday: 'short', day: '2-digit', month: '2-digit',
    year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit'
  });
}
updateClock();
setInterval(updateClock, 1000);

/* ── Toast notifications ─────────────────────────────────── */
function showToast(message, type = 'info') {
  const icons = { info: 'ℹ️', success: '✅', error: '❌' };
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `<span>${icons[type] || 'ℹ️'}</span><span>${message}</span>`;
  toastContainer.appendChild(toast);
  setTimeout(() => toast.remove(), 4000);
}

/* ── Helpers ─────────────────────────────────────────────── */
function formatDateTime(ts) {
  if (!ts) return '—';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleString('pt-BR', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit'
  });
}

function formatDateShort(ts) {
  if (!ts) return '';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleDateString('pt-BR');
}

function safeText(val, fallback = '—') {
  return (val && String(val).trim()) ? String(val).trim() : fallback;
}

function statusBadgeHTML(status) {
  const map = {
    synced:  { label: 'Sincronizado', cls: 'synced'  },
    pending: { label: 'Pendente',     cls: 'pending' },
    draft:   { label: 'Rascunho',     cls: 'draft'   },
    error:   { label: 'Erro',         cls: 'error'   },
  };
  const s = map[status] || map.draft;
  return `<span class="status-badge ${s.cls}">
    <span class="status-dot"></span>${s.label}
  </span>`;
}

function isToday(ts) {
  if (!ts) return false;
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  const now = new Date();
  return d.getFullYear() === now.getFullYear()
      && d.getMonth()    === now.getMonth()
      && d.getDate()     === now.getDate();
}

function isWithinDays(ts, days) {
  if (!ts) return false;
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return (Date.now() - d.getTime()) <= days * 86_400_000;
}

/* ── KPI computation ─────────────────────────────────────── */
function updateKPIs(reports) {
  const todayReports = reports.filter(r => isToday(r.createdAt || r.syncedAt));
  const totalOS      = todayReports.reduce((a, r) => a + (r.workOrders?.length || 0), 0);
  const equipSet     = new Set(todayReports.map(r => r.equipment).filter(Boolean));
  const colabSet     = new Set();
  todayReports.forEach(r =>
    (r.executors || []).forEach(e => colabSet.add(e.registration || e.name))
  );

  animateKPI('kpi-total',         todayReports.length);
  animateKPI('kpi-os',            totalOS);
  animateKPI('kpi-equipamentos',  equipSet.size);
  animateKPI('kpi-colaboradores', colabSet.size);
}

function animateKPI(id, target) {
  const el  = document.getElementById(id);
  if (!el) return;
  const start    = parseInt(el.textContent) || 0;
  const duration = 600;
  const startTs  = performance.now();
  function step(ts) {
    const progress = Math.min((ts - startTs) / duration, 1);
    el.textContent = Math.round(start + (target - start) * easeOut(progress));
    if (progress < 1) requestAnimationFrame(step);
  }
  requestAnimationFrame(step);
}

function easeOut(t) { return 1 - Math.pow(1 - t, 3); }

/* ── Filtering ───────────────────────────────────────────── */
function applyFilters() {
  const search  = filterSearch.value.toLowerCase().trim();
  const turno   = filterTurno.value;
  const datePer = filterData.value;

  filteredReports = allReports.filter(r => {
    // Date filter
    const ts = r.createdAt || r.syncedAt;
    if (datePer === 'today' && !isToday(ts)) return false;
    if (datePer === '7'     && !isWithinDays(ts, 7))  return false;
    if (datePer === '30'    && !isWithinDays(ts, 30)) return false;

    // Turno filter
    if (turno && r.shift !== turno) return false;

    // Text search
    if (search) {
      const haystack = [
        r.mineLocation, r.equipment, r.team,
        ...(r.executors || []).map(e => `${e.name} ${e.registration}`),
        ...(r.workOrders || []).map(o => `${o.number} ${o.location}`),
      ].join(' ').toLowerCase();
      if (!haystack.includes(search)) return false;
    }

    return true;
  });

  renderTable(filteredReports);
}

/* ── Table rendering ─────────────────────────────────────── */
let knownIds = new Set();

function renderTable(reports) {
  countBadge.textContent = reports.length;

  if (reports.length === 0) {
    tableSection.style.display = 'none';
    emptyState.style.display   = 'block';
    return;
  }

  tableSection.style.display = '';
  emptyState.style.display   = 'none';

  tbody.innerHTML = reports.map(r => {
    const isNew  = !knownIds.has(r.uuid) && r.status === 'synced';
    const rowCls = isNew ? 'new-entry' : '';
    const execs  = (r.executors || [])
      .map(e => `<span class="exec-chip">${safeText(e.name)}</span>`)
      .join('');

    return `
      <tr class="${rowCls}" data-uuid="${r.uuid}" tabindex="0" role="button"
          aria-label="Abrir relatório de ${safeText(r.mineLocation)}">
        <td class="muted">${formatDateTime(r.createdAt || r.syncedAt)}</td>
        <td><strong>${safeText(r.mineLocation)}</strong></td>
        <td>${safeText(r.shift)}</td>
        <td>${safeText(r.team)}</td>
        <td>${safeText(r.equipment)}</td>
        <td><div class="executantes-cell">${execs || '—'}</div></td>
        <td><strong>${r.workOrders?.length || 0}</strong></td>
        <td>${statusBadgeHTML(r.status)}</td>
      </tr>`;
  }).join('');

  // Mark all current IDs as known (no longer "new")
  reports.forEach(r => knownIds.add(r.uuid));

  // Row click → open modal
  tbody.querySelectorAll('tr[data-uuid]').forEach(row => {
    const handler = () => {
      const report = allReports.find(r => r.uuid === row.dataset.uuid);
      if (report) openModal(report);
    };
    row.addEventListener('click', handler);
    row.addEventListener('keydown', e => e.key === 'Enter' && handler());
  });
}

/* ── Modal ───────────────────────────────────────────────── */
function openModal(report) {
  currentReport = report;
  modalTitle.textContent = `Relatório — ${safeText(report.mineLocation)}`;
  modalMeta.textContent  =
    `${formatDateTime(report.createdAt || report.syncedAt)}  •  Turno ${safeText(report.shift)}  •  ${statusBadgeHTML(report.status).replace(/<[^>]+>/g, '')}`;

  // Collect all photos
  const allPhotos = (report.workOrders || []).flatMap(o => o.photos || []);

  modalBody.innerHTML = `
    <!-- Identificação -->
    <div class="modal-section-title">🏭 Identificação</div>
    <div class="info-grid">
      <div class="info-item"><label>Área / Mina</label><span>${safeText(report.mineLocation)}</span></div>
      <div class="info-item"><label>Turno</label><span>${safeText(report.shift)}</span></div>
      <div class="info-item"><label>Turma</label><span>${safeText(report.team)}</span></div>
      <div class="info-item"><label>Equipamento</label><span>${safeText(report.equipment)}</span></div>
      <div class="info-item"><label>Horímetro Inicial</label><span>${safeText(String(report.horimeterStart ?? ''))}</span></div>
      <div class="info-item"><label>Horímetro Final</label><span>${safeText(String(report.horimeterEnd ?? ''))}</span></div>
      <div class="info-item"><label>Data do Registro</label><span>${formatDateTime(report.createdAt || report.syncedAt)}</span></div>
      <div class="info-item"><label>Status</label><span>${report.status || 'draft'}</span></div>
    </div>

    <!-- Executantes -->
    <div class="modal-section-title">👷 Executantes</div>
    <div class="info-grid">
      ${(report.executors || []).length === 0
        ? '<p style="color:var(--text-muted);font-size:13px;">Nenhum executante informado.</p>'
        : (report.executors || []).map(e => `
            <div class="info-item">
              <label>Matrícula ${safeText(e.registration)}</label>
              <span>${safeText(e.name)}</span>
            </div>`).join('')}
    </div>

    <!-- Ordens de Serviço -->
    <div class="modal-section-title">🛠️ Ordens de Serviço</div>
    ${(report.workOrders || []).length === 0
      ? '<p style="color:var(--text-muted);font-size:13px;">Nenhuma OS registrada.</p>'
      : (report.workOrders || []).map((os, idx) => `
          <div class="os-block">
            <div class="os-block-header">
              <span>OS ${idx + 1}${os.number ? ' — Nº ' + os.number : ''}</span>
              <small>${os.startTime || ''}${os.startTime && os.endTime ? ' → ' : ''}${os.endTime || ''}</small>
            </div>
            <div class="os-block-body">
              <div class="os-field">
                <label>Local</label>
                <p>${safeText(os.location)}</p>
              </div>
              <div class="os-field description-field">
                <label><i data-lucide="align-left" style="width:14px; height:14px; margin-right:4px; vertical-align:middle;"></i> Descrição das Atividades</label>
                <div class="desc-content">${safeText(os.description)}</div>
              </div>
              <div class="os-field">
                <label><i data-lucide="package" style="width:14px; height:14px; margin-right:4px; vertical-align:middle;"></i> Materiais / Peças Utilizados</label>
                <p>${safeText(os.materials)}</p>
              </div>
            </div>
          </div>`).join('')}

    <!-- Fotos -->
    ${allPhotos.length > 0 ? `
      <div class="modal-section-title">📷 Anexo Fotográfico (${allPhotos.length} foto${allPhotos.length > 1 ? 's' : ''})</div>
      <div class="photo-gallery">
        ${allPhotos.map(src => `
          <img class="photo-thumb" src="${src}" alt="Foto de campo"
               loading="lazy" data-src="${src}" />`).join('')}
      </div>` : ''}
  `;

  // Photo lightbox
  modalBody.querySelectorAll('.photo-thumb').forEach(img => {
    img.addEventListener('click', () => openLightbox(img.dataset.src));
  });

  modalOverlay.classList.add('open');
  document.body.style.overflow = 'hidden';
  modalCloseBtn.focus();
}

function closeModal() {
  modalOverlay.classList.remove('open');
  document.body.style.overflow = '';
  currentReport = null;
}

/* ── Lightbox ────────────────────────────────────────────── */
function openLightbox(src) {
  lightboxImg.src = src;
  lightbox.classList.add('open');
}

function closeLightbox() {
  lightbox.classList.remove('open');
  lightboxImg.src = '';
}

/* ── Event listeners ─────────────────────────────────────── */
filterSearch.addEventListener('input',  applyFilters);
filterTurno .addEventListener('change', applyFilters);
filterData  .addEventListener('change', applyFilters);

btnClear.addEventListener('click', () => {
  filterSearch.value = '';
  filterTurno.value  = '';
  filterData.value   = 'today';
  applyFilters();
});

modalCloseBtn .addEventListener('click', closeModal);
modalFootClose.addEventListener('click', closeModal);
modalOverlay  .addEventListener('click', e => { if (e.target === modalOverlay) closeModal(); });

btnPrint.addEventListener('click', () => window.print());

lightboxClose.addEventListener('click', closeLightbox);
lightbox     .addEventListener('click', e => { if (e.target === lightbox) closeLightbox(); });

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') {
    if (lightbox.classList.contains('open')) closeLightbox();
    else closeModal();
  }
});

/* ── Firestore real-time listener ────────────────────────── */
function startRealtimeSync() {
  const q = query(
    collection(db, 'reports'),
    orderBy('createdAt', 'desc')
  );

  unsubscribe = onSnapshot(q,
    (snapshot) => {
      // Hide loading on first data
      loadingState.style.display = 'none';

      // Detect new additions
      snapshot.docChanges().forEach(change => {
        if (change.type === 'added') {
          const data = { uuid: change.doc.id, ...change.doc.data() };
          if (!allReports.find(r => r.uuid === data.uuid)) {
            // Only toast for truly new synced docs (not initial load)
            if (allReports.length > 0 && data.status === 'synced') {
              showToast(`Novo relatório recebido — ${safeText(data.mineLocation)}`, 'success');
            }
          }
        }
      });

      allReports = snapshot.docs.map(d => ({ uuid: d.id, ...d.data() }));
      updateKPIs(allReports);
      applyFilters();
    },
    (error) => {
      console.error('Firestore error:', error);
      loadingState.style.display = 'none';
      showToast(`Erro de conexão: ${error.message}`, 'error');
      // Show empty state on error
      tableSection.style.display = 'none';
      emptyState.style.display   = 'block';
      emptyState.querySelector('p').textContent =
        'Não foi possível conectar ao servidor. Verifique sua conexão ou as regras do Firestore.';
    }
  );
}

/* ── Init ────────────────────────────────────────────────── */
startRealtimeSync();

/* ── Actions / Creation Modal ────────────────────────────── */
window.openCreateModal = function(type) {
  const overlay = document.getElementById('create-modal-overlay');
  const title = document.getElementById('create-modal-title');
  const input1 = document.getElementById('create-input-1');
  const input2 = document.getElementById('create-input-2');
  
  overlay.style.display = 'flex';
  overlay.dataset.type = type;
  
  input1.value = '';
  input2.value = '';
  
  switch(type) {
    case 'relatorio':
      title.textContent = 'Adicionar Novo Relatório';
      break;
    case 'os':
      title.textContent = 'Adicionar Nova OS';
      break;
    case 'equipamento':
      title.textContent = 'Adicionar Novo Equipamento';
      break;
    case 'colaborador':
      title.textContent = 'Adicionar Novo Colaborador';
      break;
  }
};

window.closeCreateModal = function() {
  document.getElementById('create-modal-overlay').style.display = 'none';
};

window.saveCreateModal = async function() {
  const type = document.getElementById('create-modal-overlay').dataset.type;
  const input1 = document.getElementById('create-input-1').value.trim();
  const input2 = document.getElementById('create-input-2').value.trim();

  if (!input1) {
    showToast('O primeiro campo (Nome/Identificação) é obrigatório.', 'error');
    return;
  }

  let collectionName = 'reports';
  let entity = 'Item';
  let dataToSave = {};

  if (type === 'relatorio') {
    entity = 'Relatório';
    collectionName = 'reports';
    dataToSave = {
      mineLocation: input1,
      description: input2, // Added custom description field for quick reports
      status: 'synced',
      shift: 'A', // default
      createdAt: serverTimestamp(),
      syncedAt: serverTimestamp(),
      executors: [],
      workOrders: []
    };
  } else if (type === 'os') {
    entity = 'Ordem de Serviço';
    collectionName = 'orders';
    dataToSave = {
      number: input1,
      description: input2,
      createdAt: serverTimestamp()
    };
  } else if (type === 'equipamento') {
    entity = 'Equipamento';
    collectionName = 'equipments';
    dataToSave = {
      name: input1,
      details: input2,
      createdAt: serverTimestamp()
    };
  } else if (type === 'colaborador') {
    entity = 'Colaborador';
    collectionName = 'collaborators';
    dataToSave = {
      name: input1,
      registration: input2,
      createdAt: serverTimestamp()
    };
  }
  
  try {
    const saveBtn = document.querySelector('#create-modal-overlay .btn-print');
    const oldText = saveBtn.textContent;
    saveBtn.textContent = 'Salvando...';
    saveBtn.disabled = true;

    await addDoc(collection(db, collectionName), dataToSave);
    
    saveBtn.textContent = oldText;
    saveBtn.disabled = false;
    window.closeCreateModal();
    showToast(`${entity} adicionado com sucesso!`, 'success');
  } catch (error) {
    console.error('Error adding document: ', error);
    showToast(`Erro ao salvar: ${error.message}`, 'error');
    const saveBtn = document.querySelector('#create-modal-overlay .btn-print');
    if(saveBtn) {
       saveBtn.textContent = 'Salvar Dados';
       saveBtn.disabled = false;
    }
  }
};
