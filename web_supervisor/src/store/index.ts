import { configureStore, createSlice } from '@reduxjs/toolkit';
import type { PayloadAction } from '@reduxjs/toolkit';

interface AuthState {
  isAuthenticated: boolean;
  user: {
    name: string;
    role: string;
    username: string;
  } | null;
}

const initialAuth: AuthState = {
  isAuthenticated: localStorage.getItem('cmoc_auth') === 'true',
  user: JSON.parse(localStorage.getItem('cmoc_user') || 'null') || (localStorage.getItem('cmoc_auth') === 'true' ? {
    name: 'Eng. Pedro Santos',
    role: 'Supervisor de Mina',
    username: 'pedro.santos'
  } : null)
};

const authSlice = createSlice({
  name: 'auth',
  initialState: initialAuth,
  reducers: {
    login: (state, action: PayloadAction<{ username: string; name: string; role: string }>) => {
      state.isAuthenticated = true;
      state.user = {
        name: action.payload.name,
        role: action.payload.role,
        username: action.payload.username
      };
      localStorage.setItem('cmoc_auth', 'true');
      localStorage.setItem('cmoc_user', JSON.stringify(state.user));
    },
    logout: (state) => {
      state.isAuthenticated = false;
      state.user = null;
      localStorage.removeItem('cmoc_auth');
      localStorage.removeItem('cmoc_user');
    }
  }
});

interface ThemeState {
  mode: 'light' | 'dark';
}

const initialTheme: ThemeState = {
  mode: (localStorage.getItem('cmoc_theme') as 'light' | 'dark') || 'light'
};

const themeSlice = createSlice({
  name: 'theme',
  initialState: initialTheme,
  reducers: {
    toggleTheme: (state) => {
      state.mode = state.mode === 'light' ? 'dark' : 'light';
      localStorage.setItem('cmoc_theme', state.mode);
      if (state.mode === 'dark') {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    },
    initTheme: (state) => {
      if (state.mode === 'dark') {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
  }
});

interface UiState {
  sidebarOpen: boolean;
}

const initialUi: UiState = {
  sidebarOpen: true
};

const uiSlice = createSlice({
  name: 'ui',
  initialState: initialUi,
  reducers: {
    toggleSidebar: (state) => {
      state.sidebarOpen = !state.sidebarOpen;
    }
  }
});

export const store = configureStore({
  reducer: {
    auth: authSlice.reducer,
    theme: themeSlice.reducer,
    ui: uiSlice.reducer
  }
});

export const { login, logout } = authSlice.actions;
export const { toggleTheme, initTheme } = themeSlice.actions;
export const { toggleSidebar } = uiSlice.actions;

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
