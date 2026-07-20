import { useEffect, useState } from 'react';
import { db, collection, onSnapshot, query, orderBy, deleteDoc, doc } from '../services/firebase';
import { Link, useNavigate } from 'react-router-dom';
import { 
  Search, Plus, Eye, Edit2, Trash2, MapPin, ClipboardList
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface Executor {
  name: string;
  registration: string;
}

interface WorkOrder {
  number: string;
  location: string;
  startTime: string;
  endTime: string;
  description: string;
  materials: string;
}

interface Report {
  uuid: string;
  mineLocation: string;
  shift: string;
  team: string;
  equipment: string;
  status: string;
  createdAt: any;
  supervisorName?: string;
  priority?: string;
  executors?: Executor[];
  workOrders?: WorkOrder[];
}

export default function ReportsList() {
  const navigate = useNavigate();
  const [reports, setReports] = useState<Report[]>([]);
  const [filteredReports, setFilteredReports] = useState<Report[]>([]);
  const [loading, setLoading] = useState(true);
  
  // Search & Filter state
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedShift, setSelectedShift] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('');
  const [selectedPriority, setSelectedPriority] = useState('');
  const [selectedArea, setSelectedArea] = useState('');
  const [selectedPeriod, setSelectedPeriod] = useState('all'); // all, today, yesterday, 7, 30
  
  // Pagination & Sorting state
  const [currentPage, setCurrentPage] = useState(1);
  const [sortField, setSortField] = useState<keyof Report>('createdAt');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  const itemsPerPage = 8;

  // Confirm delete modal state
  const [reportToDelete, setReportToDelete] = useState<string | null>(null);

  useEffect(() => {
    const q = query(collection(db, 'reports'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const docs = snapshot.docs.map(d => ({ uuid: d.id, ...d.data() } as Report));
      setReports(docs);
      setLoading(false);
    }, (error) => {
      console.error('Error fetching reports: ', error);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  // Filter application
  useEffect(() => {
    let result = [...reports];

    // Search Term (search by OS number, supervisor, executant, area, mina, equipment, shift, team)
    if (searchTerm.trim() !== '') {
      const term = searchTerm.toLowerCase();
      result = result.filter(r => 
        (r.mineLocation?.toLowerCase().includes(term)) ||
        (r.shift?.toLowerCase().includes(term)) ||
        (r.team?.toLowerCase().includes(term)) ||
        (r.equipment?.toLowerCase().includes(term)) ||
        (r.supervisorName?.toLowerCase().includes(term)) ||
        (r.executors?.some(e => e.name.toLowerCase().includes(term) || e.registration.toLowerCase().includes(term))) ||
        (r.workOrders?.some(o => o.number.toLowerCase().includes(term) || o.description.toLowerCase().includes(term)))
      );
    }

    // Quick filters
    if (selectedShift) result = result.filter(r => r.shift === selectedShift);
    if (selectedStatus) result = result.filter(r => r.status === selectedStatus);
    if (selectedPriority) result = result.filter(r => r.priority === selectedPriority);
    if (selectedArea) result = result.filter(r => r.mineLocation?.toLowerCase().includes(selectedArea.toLowerCase()));

    // Period filtering
    if (selectedPeriod !== 'all') {
      const now = new Date();
      result = result.filter(r => {
        if (!r.createdAt) return false;
        const date = r.createdAt.toDate ? r.createdAt.toDate() : new Date(r.createdAt);
        
        if (selectedPeriod === 'today') {
          return date.toDateString() === now.toDateString();
        } else if (selectedPeriod === 'yesterday') {
          const yesterday = new Date();
          yesterday.setDate(now.getDate() - 1);
          return date.toDateString() === yesterday.toDateString();
        } else if (selectedPeriod === '7') {
          const diff = now.getTime() - date.getTime();
          return diff <= 7 * 24 * 60 * 60 * 1000;
        } else if (selectedPeriod === '30') {
          const diff = now.getTime() - date.getTime();
          return diff <= 30 * 24 * 60 * 60 * 1000;
        }
        return true;
      });
    }

    // Sorting
    result.sort((a, b) => {
      let aVal = a[sortField];
      let bVal = b[sortField];

      // Handle FireStore timestamp sorting
      if (sortField === 'createdAt') {
        const aTime = a.createdAt?.toDate ? a.createdAt.toDate().getTime() : new Date(a.createdAt || 0).getTime();
        const bTime = b.createdAt?.toDate ? b.createdAt.toDate().getTime() : new Date(b.createdAt || 0).getTime();
        return sortOrder === 'asc' ? aTime - bTime : bTime - aTime;
      }

      if (typeof aVal === 'string' && typeof bVal === 'string') {
        return sortOrder === 'asc' 
          ? aVal.localeCompare(bVal) 
          : bVal.localeCompare(aVal);
      }
      return 0;
    });

    setFilteredReports(result);
    setCurrentPage(1); // reset to page 1 on filter
  }, [reports, searchTerm, selectedShift, selectedStatus, selectedPriority, selectedArea, selectedPeriod, sortField, sortOrder]);

  // Handle Sort Toggle
  const handleSort = (field: keyof Report) => {
    if (sortField === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortOrder('asc');
    }
  };

  // Pagination compute
  const totalPages = Math.ceil(filteredReports.length / itemsPerPage) || 1;
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredReports.slice(indexOfFirstItem, indexOfLastItem);

  const handleDelete = async (uuid: string) => {
    try {
      await deleteDoc(doc(db, 'reports', uuid));
      setReportToDelete(null);
    } catch (e) {
      console.error('Failed to delete report: ', e);
      alert('Erro ao excluir o relatório.');
    }
  };

  const getStatusBadge = (status?: string) => {
    switch (status) {
      case 'synced':
        return <span className="px-2.5 py-1 bg-green-100 dark:bg-green-950/20 text-cmoc-green text-xs font-bold rounded-full border border-cmoc-green/20">Sincronizado</span>;
      case 'pending':
        return <span className="px-2.5 py-1 bg-yellow-100 dark:bg-yellow-950/20 text-yellow-500 text-xs font-bold rounded-full border border-yellow-500/20">Pendente</span>;
      case 'draft':
        return <span className="px-2.5 py-1 bg-slate-100 dark:bg-slate-800 text-slate-500 text-xs font-bold rounded-full border border-slate-300 dark:border-slate-700">Rascunho</span>;
      default:
        return <span className="px-2.5 py-1 bg-red-100 dark:bg-red-950/20 text-red-500 text-xs font-bold rounded-full border border-red-500/20">Erro</span>;
    }
  };

  const getPriorityBadge = (p?: string) => {
    if (p === 'Alta' || p === 'Critica') return <span className="text-red-500 text-xs font-bold">🔴 Alta</span>;
    if (p === 'Media') return <span className="text-yellow-500 text-xs font-bold">🟡 Média</span>;
    return <span className="text-cmoc-green text-xs font-bold">🟢 Baixa</span>;
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-200 relative">
      {/* Title / Action bar */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-3xl font-extrabold text-cmoc-blue dark:text-white font-outfit">
            Módulo de Relatórios de Campo
          </h1>
          <p className="text-slate-500 dark:text-slate-400 text-sm">
            Gerenciamento, auditoria e exportação de diários subterrâneos.
          </p>
        </div>
        <Link 
          to="/reports/new"
          className="flex items-center gap-2 px-5 py-3 bg-cmoc-blue hover:bg-cmoc-purple text-white font-bold rounded-xl shadow-lg transition-all duration-200 active:scale-95"
        >
          <Plus size={18} />
          Adicionar Relatório
        </Link>
      </div>

      {/* Advanced Filter Bar */}
      <div className="glass rounded-2xl p-5 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
        <div className="flex flex-col md:flex-row gap-4">
          {/* Smart Search */}
          <div className="relative flex-1">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
              <Search size={18} />
            </div>
            <input 
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Buscar por OS, Supervisor, Executante, Equipamento, Área, etc..."
              className="w-full pl-10 pr-4 py-2.5 bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-xl focus:outline-none focus:ring-2 focus:ring-cmoc-purple focus:border-transparent transition-all text-sm"
            />
          </div>
          
          {/* Period quick filter */}
          <div className="flex gap-2 shrink-0 overflow-x-auto pb-1 no-scrollbar">
            {[
              { id: 'all', label: 'Todos' },
              { id: 'today', label: 'Hoje' },
              { id: 'yesterday', label: 'Ontem' },
              { id: '7', label: '7 Dias' },
              { id: '30', label: '30 Dias' }
            ].map(p => (
              <button
                key={p.id}
                onClick={() => setSelectedPeriod(p.id)}
                className={`px-4 py-2 text-xs font-bold rounded-xl transition-all ${
                  selectedPeriod === p.id 
                    ? 'bg-cmoc-purple text-white' 
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-500 hover:bg-slate-200'
                }`}
              >
                {p.label}
              </button>
            ))}
          </div>
        </div>

        {/* Dropdowns filters */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 pt-2 border-t border-slate-100 dark:border-slate-800/80">
          <select 
            value={selectedShift} 
            onChange={(e) => setSelectedShift(e.target.value)}
            className="px-3 py-2 text-xs font-semibold bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-xl focus:outline-none dark:text-white"
          >
            <option value="">Todos os Turnos</option>
            <option value="A">Turno A</option>
            <option value="B">Turno B</option>
            <option value="C">Turno C</option>
          </select>
          
          <select 
            value={selectedStatus} 
            onChange={(e) => setSelectedStatus(e.target.value)}
            className="px-3 py-2 text-xs font-semibold bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-xl focus:outline-none dark:text-white"
          >
            <option value="">Todos os Status</option>
            <option value="synced">Sincronizado</option>
            <option value="pending">Pendente</option>
            <option value="draft">Rascunho</option>
          </select>

          <select 
            value={selectedPriority} 
            onChange={(e) => setSelectedPriority(e.target.value)}
            className="px-3 py-2 text-xs font-semibold bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-xl focus:outline-none dark:text-white"
          >
            <option value="">Todas as Prioridades</option>
            <option value="Alta">Alta</option>
            <option value="Media">Média</option>
            <option value="Baixa">Baixa</option>
          </select>

          <input 
            type="text"
            value={selectedArea}
            onChange={(e) => setSelectedArea(e.target.value)}
            placeholder="Filtrar por Área / Mina..."
            className="px-3 py-2 text-xs font-semibold bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-xl focus:outline-none dark:text-white"
          />
        </div>
      </div>

      {/* Table Section */}
      <div className="glass rounded-2xl border border-slate-200/50 dark:border-slate-800/80 shadow-md overflow-hidden">
        {loading ? (
          /* Skeleton loading */
          <div className="p-6 space-y-4">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="flex items-center justify-between gap-4 h-12 bg-slate-100 dark:bg-slate-800 rounded-xl animate-pulse" />
            ))}
          </div>
        ) : filteredReports.length === 0 ? (
          <div className="p-12 text-center flex flex-col items-center justify-center">
            <div className="w-12 h-12 rounded-xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center mb-4 text-slate-400">
              <ClipboardList size={24} />
            </div>
            <h3 className="font-bold text-slate-700 dark:text-white text-base">Nenhum relatório encontrado</h3>
            <p className="text-slate-400 text-xs mt-1">Experimente alterar os termos de pesquisa ou remover os filtros aplicados.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-50 dark:bg-slate-900/50 text-slate-400 text-xs uppercase font-extrabold border-b border-slate-150 dark:border-slate-800">
                  <th className="px-6 py-4 cursor-pointer select-none hover:text-cmoc-purple" onClick={() => handleSort('createdAt')}>
                    Data / Hora {sortField === 'createdAt' && (sortOrder === 'asc' ? '▲' : '▼')}
                  </th>
                  <th className="px-6 py-4 cursor-pointer select-none hover:text-cmoc-purple" onClick={() => handleSort('mineLocation')}>
                    Mina / Local {sortField === 'mineLocation' && (sortOrder === 'asc' ? '▲' : '▼')}
                  </th>
                  <th className="px-6 py-4">Turno</th>
                  <th className="px-6 py-4">Equipamento</th>
                  <th className="px-6 py-4">OSs Associadas</th>
                  <th className="px-6 py-4">Prioridade</th>
                  <th className="px-6 py-4">Status</th>
                  <th className="px-6 py-4 text-right">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80 text-sm font-semibold">
                {currentItems.map((report) => {
                  const date = report.createdAt?.toDate 
                    ? report.createdAt.toDate() 
                    : new Date(report.createdAt || Date.now());
                  
                  return (
                    <tr key={report.uuid} className="hover:bg-slate-50/40 dark:hover:bg-slate-900/10 transition-colors">
                      <td className="px-6 py-4">
                        <div className="flex flex-col">
                          <span className="text-cmoc-blue dark:text-white font-bold">
                            {date.toLocaleDateString('pt-BR')}
                          </span>
                          <span className="text-slate-400 text-xs">
                            {date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-slate-700 dark:text-slate-300">
                        <div className="flex items-center gap-1.5">
                          <MapPin size={14} className="text-cmoc-purple shrink-0" />
                          <span>{report.mineLocation}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="px-2 py-0.5 bg-slate-100 dark:bg-slate-800 text-slate-500 rounded-lg text-xs">
                          Turno {report.shift || 'A'}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-slate-500 dark:text-slate-400">{report.equipment || '—'}</td>
                      <td className="px-6 py-4">
                        <div className="flex gap-1 flex-wrap">
                          {report.workOrders && report.workOrders.length > 0 ? (
                            report.workOrders.map((os, idx) => (
                              <span key={idx} className="px-2 py-0.5 bg-cmoc-blue/5 dark:bg-cmoc-blue/20 text-cmoc-blue dark:text-white text-xs rounded border border-cmoc-blue/10">
                                {os.number}
                              </span>
                            ))
                          ) : (
                            <span className="text-slate-400 text-xs">—</span>
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4">{getPriorityBadge(report.priority || 'Baixa')}</td>
                      <td className="px-6 py-4">{getStatusBadge(report.status)}</td>
                      <td className="px-6 py-4 text-right">
                        <div className="flex justify-end gap-2">
                          <button 
                            onClick={() => navigate(`/reports/${report.uuid}`)}
                            className="p-1.5 text-cmoc-blue dark:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-colors"
                            title="Visualizar Página do Relatório"
                          >
                            <Eye size={16} />
                          </button>
                          <button 
                            onClick={() => navigate(`/reports/edit/${report.uuid}`)}
                            className="p-1.5 text-cmoc-purple hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-colors"
                            title="Editar Relatório"
                          >
                            <Edit2 size={16} />
                          </button>
                          <button 
                            onClick={() => setReportToDelete(report.uuid)}
                            className="p-1.5 text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 rounded-lg transition-colors"
                            title="Excluir Relatório"
                          >
                            <Trash2 size={16} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        {/* Pagination Footer */}
        {!loading && filteredReports.length > 0 && (
          <div className="px-6 py-4 bg-slate-50 dark:bg-slate-900/30 border-t border-slate-150 dark:border-slate-800/80 flex justify-between items-center text-xs font-semibold text-slate-500">
            <span>
              Exibindo de {indexOfFirstItem + 1} a {Math.min(indexOfLastItem, filteredReports.length)} de {filteredReports.length} relatórios
            </span>
            <div className="flex gap-2">
              <button 
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                disabled={currentPage === 1}
                className="px-3 py-1.5 rounded-lg bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 hover:bg-slate-100 disabled:opacity-50"
              >
                Anterior
              </button>
              {[...Array(totalPages)].map((_, i) => (
                <button
                  key={i}
                  onClick={() => setCurrentPage(i + 1)}
                  className={`w-8 h-8 rounded-lg ${
                    currentPage === i + 1 
                      ? 'bg-cmoc-blue text-white' 
                      : 'bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 hover:bg-slate-100 text-slate-500'
                  }`}
                >
                  {i + 1}
                </button>
              ))}
              <button 
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                disabled={currentPage === totalPages}
                className="px-3 py-1.5 rounded-lg bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 hover:bg-slate-100 disabled:opacity-50"
              >
                Próximo
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Confirm Delete Dialog */}
      <AnimatePresence>
        {reportToDelete && (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              className="bg-white dark:bg-cmoc-dark-card rounded-2xl shadow-xl max-w-sm w-full p-6 border border-slate-200/50 dark:border-slate-800/80"
            >
              <div className="flex items-center gap-3 text-red-500 mb-4">
                <Trash2 size={28} />
                <h3 className="text-lg font-bold font-outfit text-slate-700 dark:text-white">Excluir Relatório?</h3>
              </div>
              <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed mb-6">
                Esta ação é irreversível e excluirá permanentemente o relatório selecionado do banco de dados do Firebase.
              </p>
              <div className="flex justify-end gap-3 text-xs font-bold">
                <button 
                  onClick={() => setReportToDelete(null)}
                  className="px-4 py-2 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:text-white"
                >
                  Cancelar
                </button>
                <button 
                  onClick={() => handleDelete(reportToDelete)}
                  className="px-4 py-2 rounded-xl bg-red-500 hover:bg-red-600 text-white"
                >
                  Confirmar Exclusão
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
