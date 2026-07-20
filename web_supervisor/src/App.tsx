import React, { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import type { RootState } from './store';
import { initTheme } from './store';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import ReportsList from './pages/ReportsList';
import ReportForm from './pages/ReportForm';
import ReportDetails from './pages/ReportDetails';
import Placeholder from './pages/Placeholder';
import Platforms from './pages/Platforms';
import Telemetry from './pages/Telemetry';
import GasMonitor from './pages/GasMonitor';
import DashboardLayout from './layouts/DashboardLayout';

// Component to protect routes requiring authentication
function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}

// Component to redirect logged in users away from login page
function PublicRoute({ children }: { children: React.ReactNode }) {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);

  if (isAuthenticated) {
    return <Navigate to="/dashboard" replace />;
  }

  return <>{children}</>;
}

function App() {
  const dispatch = useDispatch();

  useEffect(() => {
    // Initial theme set from Redux/LocalStorage
    dispatch(initTheme());
  }, [dispatch]);

  return (
    <BrowserRouter>
      <Routes>
        {/* Public Routes */}
        <Route 
          path="/login" 
          element={
            <PublicRoute>
              <Login />
            </PublicRoute>
          } 
        />

        <Route 
          path="/register" 
          element={
            <PublicRoute>
              <Register />
            </PublicRoute>
          } 
        />

        {/* Protected Routes inside DashboardLayout */}
        <Route 
          path="/dashboard" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <Dashboard />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/reports" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <ReportsList />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/reports/new" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <ReportForm />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/reports/edit/:id" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <ReportForm />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/reports/:id" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <ReportDetails />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        {/* Specific functional pages */}
        <Route 
          path="/other/equipments" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <Platforms />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/other/telemetry" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <Telemetry />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        <Route 
          path="/other/gas-monitor" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <GasMonitor />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        {/* Placeholder pages to make sure no menu is non-functional */}
        <Route 
          path="/other/:page" 
          element={
            <ProtectedRoute>
              <DashboardLayout>
                <Placeholder />
              </DashboardLayout>
            </ProtectedRoute>
          } 
        />

        {/* Fallbacks */}
        <Route path="/" element={<Navigate to="/dashboard" replace />} />
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
