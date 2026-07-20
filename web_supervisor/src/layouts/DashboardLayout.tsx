import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import type { RootState } from '../store';
import { toggleSidebar, toggleTheme, logout } from '../store';
import { useNavigate, useLocation, Link } from 'react-router-dom';
import { 
  LayoutDashboard, 
  FileText, 
  Wrench, 
  Network, 
  Truck, 
  Users, 
  UserCheck, 
  FolderTree, 
  Layers, 
  Map as MapIcon, 
  ClipboardCheck, 
  AlertTriangle, 
  FolderOpen, 
  BarChart3, 
  ShieldCheck, 
  Settings, 
  HelpCircle, 
  Menu, 
  Sun, 
  Moon, 
  Bell, 
  LogOut, 
  ChevronLeft, 
  ChevronRight, 
  Wifi, 
  WifiOff,
  Activity,
  Wind
} from 'lucide-react';

interface SidebarItemProps {
  icon: React.ReactNode;
  label: string;
  path: string;
  collapsed: boolean;
  active: boolean;
}

function SidebarItem({ icon, label, path, collapsed, active }: SidebarItemProps) {
  return (
    <Link 
      to={path}
      className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
        active 
          ? 'bg-cmoc-purple text-white shadow-lg shadow-cmoc-purple/20' 
          : 'text-cmoc-gray-dark/70 dark:text-cmoc-white/70 hover:bg-slate-100 dark:hover:bg-slate-800/50 hover:text-cmoc-blue dark:hover:text-white'
      }`}
    >
      <div className={`transition-transform duration-200 group-hover:scale-110 ${active ? 'text-white' : 'text-cmoc-blue/70 dark:text-cmoc-purple/80 dark:group-hover:text-cmoc-purple'}`}>
        {icon}
      </div>
      {!collapsed && (
        <span className="font-semibold text-sm whitespace-nowrap transition-opacity duration-200">
          {label}
        </span>
      )}
    </Link>
  );
}

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const sidebarOpen = useSelector((state: RootState) => state.ui.sidebarOpen);
  const themeMode = useSelector((state: RootState) => state.theme.mode);
  const user = useSelector((state: RootState) => state.auth.user);
  
  const [time, setTime] = useState(new Date());
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [notificationsOpen, setNotificationsOpen] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    
    const handleOnline = () => setIsOnline(true);
    const handleOffline = () => setIsOnline(false);
    
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      clearInterval(timer);
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  const handleLogout = () => {
    dispatch(logout());
    navigate('/');
  };

  const menuItems = [
    { icon: <LayoutDashboard size={20} />, label: 'Dashboard', path: '/dashboard' },
    { icon: <FileText size={20} />, label: 'Relatórios', path: '/reports' },
    { icon: <Wrench size={20} />, label: 'Ordens de Serviço', path: '/other/orders' },
    { icon: <Network size={20} />, label: 'Infraestrutura', path: '/other/infra' },
    { icon: <Truck size={20} />, label: 'Plataformas', path: '/other/equipments' },
    { icon: <Users size={20} />, label: 'Equipes', path: '/other/teams' },
    { icon: <UserCheck size={20} />, label: 'Colaboradores', path: '/other/collaborators' },
    { icon: <FolderTree size={20} />, label: 'Áreas', path: '/other/areas' },
    { icon: <Layers size={20} />, label: 'Minas', path: '/other/mines' },
    { icon: <MapIcon size={20} />, label: 'Mapas', path: '/other/maps' },
    { icon: <ClipboardCheck size={20} />, label: 'Checklist', path: '/other/checklist' },
    { icon: <Activity size={20} />, label: 'Telemetria IoT', path: '/other/telemetry' },
    { icon: <Wind size={20} />, label: 'Monitor de Gases', path: '/other/gas-monitor' },
    { icon: <AlertTriangle size={20} />, label: 'Ocorrências', path: '/other/occurrences' },
    { icon: <FolderOpen size={20} />, label: 'Documentos', path: '/other/documents' },
    { icon: <BarChart3 size={20} />, label: 'Indicadores', path: '/other/indicators' },
    { icon: <ShieldCheck size={20} />, label: 'Auditoria', path: '/other/audit' },
    { icon: <Settings size={20} />, label: 'Configurações', path: '/other/settings' },
    { icon: <HelpCircle size={20} />, label: 'Ajuda', path: '/other/help' },
  ];

  return (
    <div className="flex h-screen bg-cmoc-gray-light dark:bg-cmoc-dark-bg text-cmoc-gray-dark dark:text-cmoc-white transition-colors duration-200 overflow-hidden">
      {/* Sidebar */}
      <aside 
        className={`bg-white dark:bg-cmoc-dark-menu border-r border-slate-200 dark:border-slate-800/80 flex flex-col transition-all duration-300 z-30 ${
          sidebarOpen ? 'w-64' : 'w-20'
        }`}
      >
        {/* Brand Header */}
        <div className="h-16 flex items-center justify-between px-4 border-b border-slate-200 dark:border-slate-800/80">
          <div className="flex items-center gap-3 overflow-hidden">
            <img 
              src="/logo.svg" 
              alt="CMOC" 
              className="h-8 w-8 object-contain shrink-0" 
            />
            {sidebarOpen && (
              <span className="font-extrabold text-cmoc-blue dark:text-white tracking-wide text-base whitespace-nowrap font-outfit">
                CMOC MINING
              </span>
            )}
          </div>
          <button 
            onClick={() => dispatch(toggleSidebar())}
            className="p-1.5 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 text-cmoc-blue dark:text-white hidden md:block"
          >
            {sidebarOpen ? <ChevronLeft size={18} /> : <ChevronRight size={18} />}
          </button>
        </div>

        {/* Navigation Items */}
        <nav className="flex-1 overflow-y-auto p-3 space-y-1.5 no-scrollbar">
          {menuItems.map((item, idx) => (
            <SidebarItem
              key={idx}
              icon={item.icon}
              label={item.label}
              path={item.path}
              collapsed={!sidebarOpen}
              active={location.pathname === item.path || (item.path !== '/dashboard' && location.pathname.startsWith(item.path))}
            />
          ))}
        </nav>

        {/* Footer Sidebar (Logout) */}
        <div className="p-3 border-t border-slate-200 dark:border-slate-800/80">
          <button 
            onClick={handleLogout}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 font-semibold text-sm transition-colors duration-200"
          >
            <LogOut size={20} className="shrink-0" />
            {sidebarOpen && <span>Sair da Conta</span>}
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col overflow-hidden relative">
        {/* Header */}
        <header className="h-16 bg-white dark:bg-cmoc-dark-menu border-b border-slate-200 dark:border-slate-800/80 flex items-center justify-between px-6 z-20 shadow-sm shadow-slate-100 dark:shadow-none">
          <div className="flex items-center gap-4">
            <button 
              onClick={() => dispatch(toggleSidebar())}
              className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 text-cmoc-blue/80 dark:text-white md:hidden"
            >
              <Menu size={20} />
            </button>
            
            <div className="hidden sm:flex items-center gap-2">
              <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold ${
                isOnline 
                  ? 'bg-green-100 dark:bg-green-950/30 text-cmoc-green border border-cmoc-green/20' 
                  : 'bg-red-100 dark:bg-red-950/30 text-red-500 border border-red-500/20'
              }`}>
                {isOnline ? <Wifi size={12} className="animate-pulse" /> : <WifiOff size={12} />}
                {isOnline ? 'Online' : 'Offline'}
              </span>
              <span className="text-sm font-medium text-slate-500 dark:text-slate-400">
                {time.toLocaleDateString('pt-BR', { weekday: 'long', day: 'numeric', month: 'short' })}
              </span>
              <span className="text-sm font-extrabold text-cmoc-blue dark:text-white">
                {time.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
              </span>
            </div>
          </div>

          <div className="flex items-center gap-4">
            {/* Toggle Theme */}
            <button 
              onClick={() => dispatch(toggleTheme())}
              className="p-2 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-cmoc-blue dark:text-white transition-all duration-200"
              title={themeMode === 'light' ? 'Ativar Modo Escuro' : 'Ativar Modo Claro'}
            >
              {themeMode === 'light' ? <Moon size={18} /> : <Sun size={18} />}
            </button>

            {/* Notifications */}
            <div className="relative">
              <button 
                onClick={() => setNotificationsOpen(!notificationsOpen)}
                className="p-2 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-cmoc-blue dark:text-white relative transition-all duration-200"
              >
                <Bell size={18} />
                <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full animate-bounce" />
              </button>
              
              {notificationsOpen && (
                <div className="absolute right-0 mt-3 w-80 glass rounded-2xl shadow-xl border border-slate-200 dark:border-slate-800 p-4 z-50 animate-in fade-in slide-in-from-top-2 duration-200">
                  <div className="flex justify-between items-center mb-3">
                    <h3 className="font-bold text-sm text-cmoc-blue dark:text-white">Notificações</h3>
                    <span className="text-xs text-cmoc-purple cursor-pointer hover:underline">Limpar todas</span>
                  </div>
                  <div className="space-y-2 text-xs">
                    <div className="p-2 bg-slate-100/50 dark:bg-slate-900/50 rounded-xl border border-slate-200/50 dark:border-slate-800/50">
                      <span className="font-semibold text-cmoc-purple">Novo Relatório</span>
                      <p className="text-slate-500 dark:text-slate-400 mt-0.5">Enviado por Equipe Alfa na Mina Leste Nível 120.</p>
                      <span className="text-[10px] text-slate-400 mt-1 block">Há 5 min</span>
                    </div>
                    <div className="p-2 bg-slate-100/50 dark:bg-slate-900/50 rounded-xl border border-slate-200/50 dark:border-slate-800/50">
                      <span className="font-semibold text-yellow-500">Alerta de Manutenção</span>
                      <p className="text-slate-500 dark:text-slate-400 mt-0.5">Equipamento Carregadeira LHD 04 com temperatura elevada.</p>
                      <span className="text-[10px] text-slate-400 mt-1 block">Há 20 min</span>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Profile User Info */}
            <div className="flex items-center gap-3 border-l border-slate-200 dark:border-slate-800/80 pl-4">
              <div className="text-right hidden md:block">
                <div className="font-extrabold text-sm text-cmoc-blue dark:text-white font-outfit">
                  {user?.name || 'Eng. Pedro Santos'}
                </div>
                <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                  {user?.role || 'Supervisor'}
                </div>
              </div>
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cmoc-blue to-cmoc-purple text-white flex items-center justify-center font-bold font-outfit shadow-md shadow-cmoc-blue/10">
                PS
              </div>
            </div>
          </div>
        </header>

        {/* Scrollable Page Wrapper */}
        <main className="flex-1 overflow-y-auto p-6 md:p-8 relative">
          {children}
        </main>
      </div>
    </div>
  );
}
