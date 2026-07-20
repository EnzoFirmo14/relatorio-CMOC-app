import { initializeApp } from 'firebase/app';
import { 
  getFirestore, 
  collection, 
  onSnapshot, 
  query, 
  orderBy, 
  addDoc, 
  doc, 
  updateDoc, 
  deleteDoc, 
  getDoc, 
  getDocs,
  where,
  serverTimestamp 
} from 'firebase/firestore';

const firebaseConfig = {
  apiKey: 'AIzaSyBkEzrbkGFq8jEutYvQvOd6nOST0Vh9siw',
  authDomain: 'cmoc-relatorio.firebaseapp.com',
  projectId: 'cmoc-relatorio',
  storageBucket: 'cmoc-relatorio.firebasestorage.app',
  messagingSenderId: '279433346974',
  appId: '1:279433346974:android:fb05389a58d0d4f45ae08f',
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { 
  app, 
  db, 
  collection, 
  onSnapshot, 
  query, 
  orderBy, 
  addDoc, 
  doc, 
  updateDoc, 
  deleteDoc, 
  getDoc, 
  getDocs,
  where,
  serverTimestamp 
};
