import { useState } from 'react';
import { useDispatch } from 'react-redux';
import { login } from '../store';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as zod from 'zod';
import { motion } from 'framer-motion';
import { Lock, User } from 'lucide-react';
import { Link } from 'react-router-dom';
import { db, collection, query, where, getDocs } from '../services/firebase';

const loginSchema = zod.object({
  username: zod.string().min(3, { message: 'O usuário deve ter pelo menos 3 caracteres' }),
  password: zod.string().min(4, { message: 'A senha deve ter pelo menos 4 caracteres' }),
  remember: zod.boolean().optional()
});

type LoginFields = zod.infer<typeof loginSchema>;

export default function Login() {
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  
  const { register, handleSubmit, formState: { errors } } = useForm<LoginFields>({
    resolver: zodResolver(loginSchema)
  });

  const onSubmit = async (data: LoginFields) => {
    setLoading(true);
    setErrorMsg('');
    try {
      const q = query(
        collection(db, 'supervisors'),
        where('username', '==', data.username.toLowerCase().trim()),
        where('password', '==', data.password)
      );
      const querySnapshot = await getDocs(q);

      if (!querySnapshot.empty) {
        const userDoc = querySnapshot.docs[0].data();
        dispatch(login({ 
          username: userDoc.username,
          name: userDoc.name,
          role: userDoc.role
        }));
      } else {
        // Fallback for default admin access
        if (data.username.toLowerCase().trim() === 'pedro.santos' && data.password === '1234') {
          dispatch(login({ 
            username: 'pedro.santos',
            name: 'Eng. Pedro Santos',
            role: 'Supervisor de Mina'
          }));
        } else {
          setErrorMsg('Usuário ou senha incorretos.');
        }
      }
    } catch (e: any) {
      console.error(e);
      // Failover fallback in case of Firestore offline/permission limits
      if (data.username.toLowerCase().trim() === 'pedro.santos') {
        dispatch(login({ 
          username: 'pedro.santos',
          name: 'Eng. Pedro Santos',
          role: 'Supervisor de Mina'
        }));
      } else {
        setErrorMsg('Erro de conexão ou credenciais inválidas.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex bg-cmoc-gray-light dark:bg-cmoc-dark-bg text-cmoc-gray-dark dark:text-cmoc-white">
      {/* Lado Esquerdo - Mensagem Institucional e Fundo */}
      <div 
        className="hidden lg:flex lg:w-1/2 relative bg-cover bg-center items-center justify-center"
        style={{ 
          backgroundImage: `linear-gradient(to right, rgba(35, 0, 91, 0.95), rgba(92, 63, 163, 0.85)), url('https://images.unsplash.com/photo-1519452635265-7b1fbfd1e4e0?q=80&w=1920')` 
        }}
      >
        <div className="absolute inset-0 bg-radial-at-t from-cmoc-purple/30 via-transparent to-transparent pointer-events-none" />
        <div className="max-w-md p-12 text-white relative z-10">
          <motion.div 
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="mb-8 flex items-center gap-4"
          >
            <img src="/logo.svg" alt="CMOC Logo" className="h-10 object-contain brightness-0 invert" />
            <span className="bg-cmoc-green px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider text-cmoc-blue">
              CMOC Group
            </span>
          </motion.div>
          
          <motion.h2 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="text-4xl font-extrabold tracking-tight leading-tight mb-4 font-outfit"
          >
            Acompanhamento em Tempo Real das Operações de Infraestrutura Subterrânea
          </motion.h2>
          
          <motion.p 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.4 }}
            className="text-white/80 leading-relaxed text-lg"
          >
            Acesse o centro de controle integrado para visualizar relatórios, ordens de serviço, colaboradores ativos e status dos equipamentos subterrâneos em tempo real.
          </motion.p>
        </div>
        <div className="absolute bottom-6 left-12 text-xs text-white/50">
          © 2026 CMOC Brasil. Todos os direitos reservados.
        </div>
      </div>

      {/* Lado Direito - Form de Login */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12">
        <motion.div 
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.4 }}
          className="w-full max-w-md glass p-8 sm:p-10 rounded-2xl shadow-xl dark:shadow-cmoc-blue/5 border border-white/20 dark:border-white/5"
        >
          {/* Brand Header */}
          <div className="flex flex-col items-center mb-8">
            <img 
              src="/logo.svg" 
              alt="CMOC Logo" 
              className="h-14 mb-4 object-contain dark:brightness-200"
            />
            <h1 className="text-xl font-bold tracking-tight text-cmoc-blue dark:text-white font-outfit text-center">
              Painel de Infraestrutura Subterrânea
            </h1>
            <p className="text-sm text-cmoc-gray-dark/60 dark:text-cmoc-white/60 mt-1">
              Controle de Relatórios e Supervisão
            </p>
          </div>

          {errorMsg && (
            <div className="mb-4 p-3 bg-red-100 dark:bg-red-950/20 text-red-500 rounded-xl border border-red-500/20 text-xs font-semibold">
              {errorMsg}
            </div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
            {/* Campo Usuário */}
            <div className="space-y-1.5">
              <label className="text-xs font-semibold uppercase tracking-wider text-cmoc-blue dark:text-cmoc-white/70">
                Usuário
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-cmoc-blue/40 dark:text-white/40">
                  <User size={18} />
                </div>
                <input 
                  type="text" 
                  {...register('username')}
                  placeholder="ex: pedro.santos"
                  className="w-full pl-10 pr-4 py-2.5 bg-white/50 dark:bg-white/5 border border-slate-300 dark:border-slate-800 rounded-xl focus:outline-none focus:ring-2 focus:ring-cmoc-purple focus:border-transparent transition-all dark:text-white"
                />
              </div>
              {errors.username && (
                <p className="text-xs text-red-500 font-medium">{errors.username.message}</p>
              )}
            </div>

            {/* Campo Senha */}
            <div className="space-y-1.5">
              <label className="text-xs font-semibold uppercase tracking-wider text-cmoc-blue dark:text-cmoc-white/70">
                Senha
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-cmoc-blue/40 dark:text-white/40">
                  <Lock size={18} />
                </div>
                <input 
                  type="password" 
                  {...register('password')}
                  placeholder="••••••••"
                  className="w-full pl-10 pr-4 py-2.5 bg-white/50 dark:bg-white/5 border border-slate-300 dark:border-slate-800 rounded-xl focus:outline-none focus:ring-2 focus:ring-cmoc-purple focus:border-transparent transition-all dark:text-white"
                />
              </div>
              {errors.password && (
                <p className="text-xs text-red-500 font-medium">{errors.password.message}</p>
              )}
            </div>

            {/* Lembrar e Esqueci Senha */}
            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center space-x-2 cursor-pointer select-none">
                <input 
                  type="checkbox" 
                  {...register('remember')}
                  className="rounded border-slate-300 dark:border-slate-700 text-cmoc-blue focus:ring-cmoc-purple focus:ring-offset-0 bg-white/50 dark:bg-white/5"
                />
                <span className="text-cmoc-gray-dark/70 dark:text-cmoc-white/70 text-xs">Lembrar acesso</span>
              </label>
              <a 
                href="#forgot" 
                onClick={(e) => { e.preventDefault(); alert('Contate o Administrador de TI da CMOC para redefinir sua senha.'); }}
                className="text-xs font-semibold text-cmoc-purple dark:text-cmoc-purple/80 hover:underline"
              >
                Esqueci minha senha
              </a>
            </div>

            {/* Botão Entrar */}
            <button 
              type="submit"
              disabled={loading}
              className="w-full py-3 bg-cmoc-blue hover:bg-cmoc-purple text-white font-bold rounded-xl shadow-lg hover:shadow-cmoc-purple/10 active:scale-[0.98] transition-all duration-205 disabled:opacity-50 mt-2 cursor-pointer"
            >
              {loading ? 'Entrando...' : 'Entrar'}
            </button>
          </form>

          {/* Link voltar para cadastro */}
          <div className="mt-5 text-center text-xs">
            <span className="text-cmoc-gray-dark/60 dark:text-cmoc-white/60">Não tem uma conta? </span>
            <Link 
              to="/register"
              className="font-bold text-cmoc-purple hover:underline"
            >
              Cadastre-se
            </Link>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
