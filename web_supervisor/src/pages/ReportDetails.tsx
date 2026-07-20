import { useEffect, useState, useRef } from 'react';
import { db, doc, getDoc } from '../services/firebase';
import { useNavigate, useParams, Link } from 'react-router-dom';
import { 
  ChevronLeft, Printer, Share2, Edit3, Clock, MapPin, 
  User, Building2, Wrench, CheckSquare, Users,
  Image as ImageIcon, MessageSquare, FileText, CheckCircle2, PenTool
} from 'lucide-react';
import { motion } from 'framer-motion';

interface Executor {
  name: string;
  registration: string;
}

interface WorkOrder {
  number: string;
  location?: string;
  description?: string;
  startTime?: string;
  endTime?: string;
  materials?: string;
}

interface Report {
  uuid: string;
  mineLocation: string;
  shift: string;
  team: string;
  equipment: string;
  supervisorName?: string;
  responsibleCompany?: string;
  activityType?: string;
  description: string;
  objective?: string;
  materials?: string;
  toolsUsed?: string;
  priority?: string;
  riskLevel?: string;
  workPermit?: string;
  weatherCondition?: string;
  gpsCoordinates?: string;
  observations?: string;
  problemsFound?: string;
  correctiveActions?: string;
  nextActivities?: string;
  status: string;
  createdAt: any;
  executors?: Executor[];
  workOrders?: WorkOrder[];
}

export default function ReportDetails() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [report, setReport] = useState<Report | null>(null);
  const [loading, setLoading] = useState(true);
  const [activeSubTab, setActiveSubTab] = useState<'geral' | 'timeline' | 'checklist' | 'fotos' | 'comentarios' | 'assinatura'>('geral');
  const [commentText, setCommentText] = useState('');
  const [comments, setComments] = useState<Array<{author: string, date: string, text: string}>>([
    { author: 'Eng. Carlos Andrade (Gerente de Mina)', date: 'Hoje às 09:30', text: 'Atividade concluída com êxito. Parabéns à equipe pela eficiência.' }
  ]);

  // Digital Signature State
  const [signaturePin, setSignaturePin] = useState('');
  const [signedBy, setSignedBy] = useState('');
  const [signedAt, setSignedAt] = useState('');
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasSignature, setHasSignature] = useState(false);

  const startDrawing = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.strokeStyle = '#23005B';
    ctx.lineWidth = 2;
    ctx.lineCap = 'round';
    const rect = canvas.getBoundingClientRect();
    ctx.beginPath();
    ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    setIsDrawing(true);
  };

  const draw = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    const rect = canvas.getBoundingClientRect();
    ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
    ctx.stroke();
    setHasSignature(true);
  };

  const stopDrawing = () => {
    setIsDrawing(false);
  };

  const clearSignature = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasSignature(false);
    setSignedBy('');
    setSignedAt('');
  };

  const handleSign = () => {
    if (!hasSignature) {
      alert('Desenhe sua assinatura no campo acima.');
      return;
    }
    if (signaturePin.length < 4) {
      alert('O PIN de segurança deve ter pelo menos 4 dígitos.');
      return;
    }
    setSignedBy('Eng. Pedro Santos');
    setSignedAt(new Date().toLocaleString('pt-BR'));
    alert('✅ Relatório assinado digitalmente com sucesso! Você pode gerar o PDF clicando em "Imprimir / PDF".');
  };

  useEffect(() => {
    if (id) {
      const fetchReport = async () => {
        try {
          const docRef = doc(db, 'reports', id);
          const docSnap = await getDoc(docRef);
          if (docSnap.exists()) {
            setReport({ uuid: docSnap.id, ...docSnap.data() } as Report);
          } else {
            alert('Relatório não encontrado');
            navigate('/reports');
          }
        } catch (e) {
          console.error(e);
        } finally {
          setLoading(false);
        }
      };
      fetchReport();
    }
  }, [id, navigate]);

  const handlePrint = () => {
    window.print();
  };

  const handleShare = () => {
    if (navigator.share) {
      navigator.share({
        title: `Relatório de Mina CMOC - ${report?.mineLocation}`,
        text: report?.description,
        url: window.location.href
      }).catch(console.error);
    } else {
      navigator.clipboard.writeText(window.location.href);
      alert('Link do relatório copiado para a área de transferência!');
    }
  };

  const handleAddComment = (e: React.FormEvent) => {
    e.preventDefault();
    if (!commentText.trim()) return;
    setComments([
      ...comments,
      { author: 'Eng. Pedro Santos (Você)', date: 'Agora mesmo', text: commentText }
    ]);
    setCommentText('');
  };

  if (loading) {
    return (
      <div className="flex h-[60vh] items-center justify-center">
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-cmoc-purple" />
      </div>
    );
  }

  if (!report) return null;

  const date = report.createdAt?.toDate ? report.createdAt.toDate() : new Date(report.createdAt || Date.now());

  // Dummy checklist
  const checklists = [
    { item: 'Inspeção de EPIs da Turma', status: 'Concluído', desc: 'Todos os colaboradores equipados com capacete, lanterna e respirador.' },
    { item: 'Medição de Concentração de Gases', status: 'Concluído', desc: 'Níveis de O2, CO e H2S estáveis e dentro do limite seguro.' },
    { item: 'Inspeção Prévia do Teto e Paredes da Galeria', status: 'Concluído', desc: 'Verificação visual de instabilidades estruturais.' },
    { item: 'Checklist de Pré-operação da Carregadeira', status: 'Concluído', desc: 'Níveis de óleo e circuito elétrico verificados.' }
  ];

  return (
    <div className="space-y-6 max-w-5xl mx-auto print:p-0 animate-in fade-in duration-200">
      {/* Action / Title Bar */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-slate-200 dark:border-slate-800/80 pb-4 print:hidden">
        <div className="flex items-center gap-3">
          <Link 
            to="/reports"
            className="p-2 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 text-cmoc-blue dark:text-white"
          >
            <ChevronLeft size={18} />
          </Link>
          <div>
            <h1 className="text-2xl font-extrabold text-cmoc-blue dark:text-white font-outfit">
              Relatório {report.uuid.slice(0, 8).toUpperCase()}
            </h1>
            <p className="text-slate-500 dark:text-slate-400 text-xs mt-0.5">
              Criado em {date.toLocaleDateString('pt-BR')} às {date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
            </p>
          </div>
        </div>

        <div className="flex gap-2 text-xs font-bold w-full md:w-auto overflow-x-auto pb-1 md:pb-0">
          <button 
            onClick={() => navigate(`/reports/edit/${report.uuid}`)}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-white rounded-xl"
          >
            <Edit3 size={14} /> Editar
          </button>
          <button 
            onClick={handleShare}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-white rounded-xl"
          >
            <Share2 size={14} /> Compartilhar
          </button>
          <button 
            onClick={handlePrint}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-cmoc-blue hover:bg-cmoc-purple text-white rounded-xl shadow-md"
          >
            <Printer size={14} /> Imprimir / PDF
          </button>
        </div>
      </div>

      {/* Main Print Title Header (Only visible on Print) */}
      <div className="hidden print:flex justify-between items-center border-b-2 border-cmoc-blue pb-4 mb-6">
        <div>
          <img src="/logo.svg" alt="CMOC Logo" className="h-10 mb-2" />
          <h1 className="text-xl font-bold text-cmoc-blue uppercase">CMOC Brasil — Diário de Mina Subterrânea</h1>
          <p className="text-[10px] text-slate-500">ID do Relatório: {report.uuid.toUpperCase()}</p>
        </div>
        <div className="text-right text-[10px] text-slate-500">
          <div>Emissão: {new Date().toLocaleDateString('pt-BR')}</div>
          <div>Responsável: {report.supervisorName || 'Eng. Pedro Santos'}</div>
        </div>
      </div>

      {/* Report Info Grid Card */}
      <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-sm font-semibold">
          <div className="flex gap-3 items-center">
            <div className="p-2 rounded-xl bg-cmoc-blue/5 dark:bg-slate-800 text-cmoc-purple shrink-0"><MapPin size={18} /></div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase text-slate-400 font-bold">Local / Mina</span>
              <span className="text-slate-800 dark:text-slate-200">{report.mineLocation}</span>
            </div>
          </div>
          <div className="flex gap-3 items-center">
            <div className="p-2 rounded-xl bg-cmoc-blue/5 dark:bg-slate-800 text-cmoc-purple shrink-0"><Clock size={18} /></div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase text-slate-400 font-bold">Turno / Horário</span>
              <span className="text-slate-800 dark:text-slate-200">Turno {report.shift || 'A'}</span>
            </div>
          </div>
          <div className="flex gap-3 items-center">
            <div className="p-2 rounded-xl bg-cmoc-blue/5 dark:bg-slate-800 text-cmoc-purple shrink-0"><User size={18} /></div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase text-slate-400 font-bold">Supervisor</span>
              <span className="text-slate-800 dark:text-slate-200">{report.supervisorName || 'Pedro Santos'}</span>
            </div>
          </div>
          <div className="flex gap-3 items-center">
            <div className="p-2 rounded-xl bg-cmoc-blue/5 dark:bg-slate-800 text-cmoc-purple shrink-0"><Building2 size={18} /></div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase text-slate-400 font-bold">Empresa</span>
              <span className="text-slate-800 dark:text-slate-200">{report.responsibleCompany || 'CMOC Brasil'}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Tabs Menu */}
      <div className="flex gap-2 border-b border-slate-200 dark:border-slate-800/80 pb-px print:hidden">
        {[
          { id: 'geral', label: 'Resumo do Relatório', icon: <FileText size={16} /> },
          { id: 'timeline', label: 'Linha do Tempo', icon: <Clock size={16} /> },
          { id: 'checklist', label: 'Checklist de Segurança', icon: <CheckSquare size={16} /> },
          { id: 'fotos', label: 'Anexo Fotográfico', icon: <ImageIcon size={16} /> },
          { id: 'comentarios', label: 'Comentários & Histórico', icon: <MessageSquare size={16} /> },
          { id: 'assinatura', label: 'Assinatura Digital', icon: <PenTool size={16} /> }
        ].map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveSubTab(tab.id as any)}
            className={`flex items-center gap-2 px-4 py-3 text-xs font-bold border-b-2 -mb-px transition-all ${
              activeSubTab === tab.id 
                ? 'border-cmoc-purple text-cmoc-purple dark:text-cmoc-purple/80' 
                : 'border-transparent text-slate-400 hover:text-slate-600 dark:hover:text-white'
            }`}
          >
            {tab.icon}
            {tab.label}
          </button>
        ))}
      </div>

      {/* TAB CONTENT */}
      <div className="space-y-6">
        {/* SUBTAB: RESUMO GERAL (Visible in print always) */}
        {(activeSubTab === 'geral' || window.matchMedia('print').matches) && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-6"
          >
            {/* Descrição & Atividade */}
            <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
              <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Atividades Executadas</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="md:col-span-2 space-y-3">
                  <div className="text-xs font-bold text-cmoc-purple uppercase">Descrição Detalhada</div>
                  <p className="text-slate-700 dark:text-slate-300 text-sm leading-relaxed whitespace-pre-wrap">
                    {report.description}
                  </p>
                </div>
                <div className="p-4 bg-slate-50 dark:bg-slate-900 rounded-xl space-y-3 border border-slate-200/20">
                  <div className="text-xs font-bold text-cmoc-purple uppercase">Metas & Recursos</div>
                  <div className="space-y-2 text-xs font-semibold text-slate-600 dark:text-slate-400">
                    <div>Atividade: <span className="text-slate-850 dark:text-white">{report.activityType || 'Lavra'}</span></div>
                    <div>Objetivo: <span className="text-slate-850 dark:text-white">{report.objective || 'N/A'}</span></div>
                    <div>Equipamento: <span className="text-slate-850 dark:text-white">{report.equipment || 'N/A'}</span></div>
                    <div>Materiais: <span className="text-slate-850 dark:text-white">{report.materials || 'N/A'}</span></div>
                    <div>Ferramentas: <span className="text-slate-850 dark:text-white">{report.toolsUsed || 'N/A'}</span></div>
                  </div>
                </div>
              </div>
            </div>

            {/* Executantes & Ordens de serviço */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Equipe / Colaboradores */}
              <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
                <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs flex items-center gap-2">
                  <Users size={16} /> Equipe em Campo ({report.executors?.length || 0})
                </h3>
                <div className="divide-y divide-slate-100 dark:divide-slate-800/80">
                  {report.executors && report.executors.length > 0 ? (
                    report.executors.map((e, idx) => (
                      <div key={idx} className="py-2.5 flex justify-between items-center text-xs font-semibold">
                        <span className="text-slate-700 dark:text-slate-300">{e.name}</span>
                        <span className="text-slate-400 font-mono">Reg: {e.registration}</span>
                      </div>
                    ))
                  ) : (
                    <div className="text-xs text-slate-400 py-4">Nenhum executante cadastrado.</div>
                  )}
                </div>
              </div>

              {/* Ordens de serviço list */}
              <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
                <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs flex items-center gap-2">
                  <Wrench size={16} /> Ordens de Serviço Associadas ({report.workOrders?.length || 0})
                </h3>
                <div className="space-y-3">
                  {report.workOrders && report.workOrders.length > 0 ? (
                    report.workOrders.map((os, idx) => (
                      <div key={idx} className="p-3 bg-slate-50 dark:bg-slate-900 border border-slate-200/50 dark:border-slate-850 rounded-xl text-xs">
                        <div className="flex justify-between items-center font-bold text-cmoc-blue dark:text-white">
                          <span>OS {os.number}</span>
                          <span className="text-[10px] text-slate-400">{os.startTime} - {os.endTime}</span>
                        </div>
                        <p className="text-slate-500 mt-1">{os.description || 'Sem descrição cadastrada.'}</p>
                      </div>
                    ))
                  ) : (
                    <div className="text-xs text-slate-400 py-4">Nenhuma ordem de serviço associada.</div>
                  )}
                </div>
              </div>
            </div>

            {/* Segurança, Riscos & GPS */}
            <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
              <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Análise de Risco & Conformidade</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-xs font-semibold">
                <div className="space-y-1 bg-slate-50 dark:bg-slate-900 p-4 rounded-xl border border-slate-200/20">
                  <div className="text-slate-400 uppercase text-[10px]">Permissão de Trabalho (PT)</div>
                  <div className="text-sm font-bold text-cmoc-blue dark:text-white">{report.workPermit || 'PT-Liberada (Auto)'}</div>
                </div>
                <div className="space-y-1 bg-slate-50 dark:bg-slate-900 p-4 rounded-xl border border-slate-200/20">
                  <div className="text-slate-400 uppercase text-[10px]">Nível de Risco Mapeado</div>
                  <div className="text-sm font-bold text-red-500">{report.riskLevel || 'Baixo'}</div>
                </div>
                <div className="space-y-1 bg-slate-50 dark:bg-slate-900 p-4 rounded-xl border border-slate-200/20">
                  <div className="text-slate-400 uppercase text-[10px]">Localização GPS</div>
                  <div className="text-sm font-bold text-slate-700 dark:text-slate-350">{report.gpsCoordinates || 'X: 120, Y: -120m'}</div>
                </div>
              </div>
            </div>

            {/* Assinatura Digital (Visible on print) */}
            <div className="hidden print:grid grid-cols-2 gap-12 mt-12 pt-6 border-t border-slate-200">
              <div className="text-center flex flex-col items-center">
                <div className="w-48 border-b border-slate-800 mt-12" />
                <span className="text-[10px] font-bold uppercase mt-2">Pedro Santos</span>
                <span className="text-[9px] text-slate-500">Supervisor Responsável</span>
              </div>
              <div className="text-center flex flex-col items-center">
                <div className="w-48 border-b border-slate-800 mt-12" />
                <span className="text-[10px] font-bold uppercase mt-2">Gerência de Operações</span>
                <span className="text-[9px] text-slate-500">Homologado Digitalmente</span>
              </div>
            </div>
          </motion.div>
        )}

        {/* SUBTAB: TIMELINE */}
        {activeSubTab === 'timeline' && (
          <motion.div 
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md"
          >
            <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs mb-6">Linha do Tempo Operacional</h3>
            <div className="relative border-l-2 border-cmoc-purple/40 ml-4 space-y-6">
              <div className="relative pl-6">
                <span className="absolute -left-[9px] top-1.5 w-4 h-4 rounded-full bg-cmoc-purple ring-4 ring-white dark:ring-cmoc-dark-card" />
                <span className="text-xs font-semibold text-slate-400">Início do Turno ({report.shift || 'A'})</span>
                <h4 className="text-sm font-bold text-cmoc-blue dark:text-white mt-0.5">Briefing Técnico de Segurança</h4>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">Reunião prévia de mapeamento de riscos e distribuição das OS.</p>
              </div>

              {report.workOrders?.map((os, idx) => (
                <div key={idx} className="relative pl-6">
                  <span className="absolute -left-[9px] top-1.5 w-4 h-4 rounded-full bg-cmoc-green ring-4 ring-white dark:ring-cmoc-dark-card" />
                  <span className="text-xs font-semibold text-slate-400">OS {os.number} | {os.startTime || '08:00'}</span>
                  <h4 className="text-sm font-bold text-cmoc-blue dark:text-white mt-0.5">{os.description || 'Execução Operacional'}</h4>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">Atividade registrada e vinculada ao supervisor.</p>
                </div>
              ))}

              <div className="relative pl-6">
                <span className="absolute -left-[9px] top-1.5 w-4 h-4 rounded-full bg-slate-400 ring-4 ring-white dark:ring-cmoc-dark-card" />
                <span className="text-xs font-semibold text-slate-400">Fim do Turno</span>
                <h4 className="text-sm font-bold text-slate-600 dark:text-slate-400 mt-0.5">Fechamento do Relatório</h4>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">Assinatura digital e homologação via Web Supervisor.</p>
              </div>
            </div>
          </motion.div>
        )}

        {/* SUBTAB: CHECKLIST */}
        {activeSubTab === 'checklist' && (
          <motion.div 
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4"
          >
            <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Itens do Checklist Técnico</h3>
            <div className="space-y-3">
              {checklists.map((check, idx) => (
                <div key={idx} className="p-4 bg-slate-50 dark:bg-slate-900 border border-slate-200/50 dark:border-slate-850 rounded-xl flex items-start gap-3">
                  <CheckCircle2 className="text-cmoc-green shrink-0 mt-0.5" size={18} />
                  <div className="text-xs">
                    <div className="font-bold text-cmoc-blue dark:text-white">{check.item}</div>
                    <p className="text-slate-500 dark:text-slate-400 mt-0.5">{check.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}

        {/* SUBTAB: ANEXO FOTOGRÁFICO */}
        {activeSubTab === 'fotos' && (
          <motion.div 
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-6"
          >
            <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Anexo Fotográfico da Frente de Trabalho</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* Foto Antes */}
              <div className="space-y-2 border border-slate-200/50 dark:border-slate-800 rounded-xl p-3">
                <span className="text-[10px] uppercase font-bold text-slate-400">Antes da Atividade</span>
                <img 
                  src="https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?q=80&w=600" 
                  alt="Antes" 
                  className="w-full h-40 object-cover rounded-lg border border-slate-100"
                />
                <p className="text-[10px] text-slate-500">Galeria subterrânea antes da limpeza hidráulica.</p>
              </div>

              {/* Foto Durante */}
              <div className="space-y-2 border border-slate-200/50 dark:border-slate-800 rounded-xl p-3">
                <span className="text-[10px] uppercase font-bold text-slate-400">Durante a Atividade</span>
                <img 
                  src="https://images.unsplash.com/photo-1519452635265-7b1fbfd1e4e0?q=80&w=600" 
                  alt="Durante" 
                  className="w-full h-40 object-cover rounded-lg border border-slate-100"
                />
                <p className="text-[10px] text-slate-500">Operador manuseando perfuratriz de galeria.</p>
              </div>

              {/* Foto Depois */}
              <div className="space-y-2 border border-slate-200/50 dark:border-slate-800 rounded-xl p-3">
                <span className="text-[10px] uppercase font-bold text-slate-400">Depois da Atividade</span>
                <img 
                  src="https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=600" 
                  alt="Depois" 
                  className="w-full h-40 object-cover rounded-lg border border-slate-100"
                />
                <p className="text-[10px] text-slate-500">Frente de lavra limpa e escoramento concluído.</p>
              </div>
            </div>
          </motion.div>
        )}

        {/* SUBTAB: COMENTÁRIOS & HISTÓRICO */}
        {activeSubTab === 'comentarios' && (
          <motion.div 
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="grid grid-cols-1 md:grid-cols-3 gap-6"
          >
            {/* Feed de Comentarios */}
            <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md md:col-span-2 space-y-4">
              <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Comentários e Feedbacks</h3>
              
              <div className="space-y-3">
                {comments.map((comm, idx) => (
                  <div key={idx} className="p-3 bg-slate-50 dark:bg-slate-900 border border-slate-200/50 dark:border-slate-850 rounded-xl text-xs">
                    <div className="flex justify-between items-center font-bold text-slate-700 dark:text-slate-350">
                      <span>{comm.author}</span>
                      <span className="text-[10px] text-slate-400 font-normal">{comm.date}</span>
                    </div>
                    <p className="text-slate-500 dark:text-slate-400 mt-1.5 leading-relaxed">{comm.text}</p>
                  </div>
                ))}
              </div>

              {/* Novo comentário input */}
              <form onSubmit={handleAddComment} className="flex gap-2 pt-2 border-t border-slate-100 dark:border-slate-800/80">
                <input 
                  type="text"
                  value={commentText}
                  onChange={(e) => setCommentText(e.target.value)}
                  placeholder="Escreva um comentário técnico..."
                  className="flex-1 px-3 py-2 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl focus:ring-2 focus:ring-cmoc-purple focus:outline-none dark:text-white text-xs"
                />
                <button 
                  type="submit"
                  className="px-4 py-2 bg-cmoc-purple text-white text-xs font-bold rounded-xl shadow-md"
                >
                  Enviar
                </button>
              </form>
            </div>

            {/* Auditoria / Histórico de alterações */}
            <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-md space-y-4">
              <h3 className="text-sm font-bold text-cmoc-blue dark:text-white font-outfit uppercase tracking-wider text-xs">Registro de Auditoria</h3>
              <div className="space-y-3 text-[10px] font-semibold text-slate-500">
                <div className="flex gap-2">
                  <span className="w-1.5 h-1.5 bg-cmoc-green rounded-full mt-1 shrink-0" />
                  <div>
                    <span className="text-slate-750 dark:text-white">Documento Criado</span>
                    <p className="text-slate-400">Via App Mobile (Operador)</p>
                    <span className="text-[9px] text-slate-400 block mt-0.5">Há 2 horas</span>
                  </div>
                </div>
                <div className="flex gap-2">
                  <span className="w-1.5 h-1.5 bg-cmoc-purple rounded-full mt-1 shrink-0" />
                  <div>
                    <span className="text-slate-750 dark:text-white">Relatório Sincronizado</span>
                    <p className="text-slate-400">Gravado no Firestore com sucesso</p>
                    <span className="text-[9px] text-slate-400 block mt-0.5">Há 1 hora</span>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        )}
      </div>

      {/* Signature Tab */}
      {activeSubTab === 'assinatura' && (
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
          <div className="glass rounded-2xl p-6 border border-slate-200/50 dark:border-slate-800/80 shadow-sm">
            <h3 className="text-sm font-black text-cmoc-blue dark:text-white mb-4 flex items-center gap-2">
              <PenTool size={16} className="text-cmoc-purple" />
              Assinatura Digital do Supervisor
            </h3>

            {signedBy ? (
              <div className="space-y-3">
                <div className="p-4 bg-cmoc-green/10 border border-cmoc-green/30 rounded-xl">
                  <div className="flex items-center gap-2 text-cmoc-green text-sm font-black mb-2">
                    <CheckCircle2 size={18} />
                    Relatório Assinado Digitalmente
                  </div>
                  <div className="text-xs text-slate-600 dark:text-slate-300 space-y-1">
                    <p><strong>Assinado por:</strong> {signedBy}</p>
                    <p><strong>Data/Hora:</strong> {signedAt}</p>
                    <p><strong>Método:</strong> Assinatura manuscrita digital + PIN</p>
                  </div>
                </div>
                <canvas 
                  ref={canvasRef}
                  width={400} height={150}
                  className="border border-slate-200 dark:border-slate-700 rounded-xl bg-white pointer-events-none"
                />
              </div>
            ) : (
              <div className="space-y-4">
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Desenhe sua assinatura no campo abaixo e insira o PIN de segurança para autenticar este relatório.
                </p>
                <div className="relative">
                  <canvas 
                    ref={canvasRef}
                    width={400} height={150}
                    className="border-2 border-dashed border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-900 cursor-crosshair w-full"
                    onMouseDown={startDrawing}
                    onMouseMove={draw}
                    onMouseUp={stopDrawing}
                    onMouseLeave={stopDrawing}
                  />
                  {!hasSignature && (
                    <span className="absolute inset-0 flex items-center justify-center text-slate-300 dark:text-slate-600 text-sm pointer-events-none">
                      Desenhe sua assinatura aqui
                    </span>
                  )}
                </div>
                <div className="flex flex-col sm:flex-row gap-3 items-start sm:items-end">
                  <div className="flex-1">
                    <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block mb-1">PIN de Segurança</label>
                    <input
                      type="password"
                      value={signaturePin}
                      onChange={(e) => setSignaturePin(e.target.value)}
                      placeholder="••••"
                      maxLength={6}
                      className="w-full px-4 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-900 text-sm focus:outline-none focus:ring-2 focus:ring-cmoc-purple/40 dark:text-white"
                    />
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={clearSignature}
                      className="px-4 py-2.5 text-xs font-bold bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 rounded-xl hover:bg-slate-200 dark:hover:bg-slate-700"
                    >
                      Limpar
                    </button>
                    <button
                      onClick={handleSign}
                      className="px-5 py-2.5 text-xs font-bold bg-cmoc-blue hover:bg-cmoc-purple text-white rounded-xl shadow-md transition-all"
                    >
                      Assinar Relatório
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </motion.div>
      )}
    </div>
  );
}
