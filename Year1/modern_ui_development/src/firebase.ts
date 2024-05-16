import { initializeApp } from 'firebase/app';
import {
	getAuth,
	createUserWithEmailAndPassword,
	signInWithEmailAndPassword,
	signOut as authSignOut,
	onAuthStateChanged,
	User
} from 'firebase/auth';
import {
	collection,
	CollectionReference,
	doc,
	DocumentReference,
	getFirestore,
	Timestamp
} from 'firebase/firestore';

import { Status } from './components/TaskStatus';

// Initialize Firebase
initializeApp({
	apiKey: 'AIzaSyAoMEI8fxKf4NMny8KsvLd6MA86PI7DMvA',
	authDomain: 'todo-app-1f133.firebaseapp.com',
	projectId: 'todo-app-1f133',
	storageBucket: 'todo-app-1f133.appspot.com',
	messagingSenderId: '210592467964',
	appId: '1:210592467964:web:1a655400400ecd50d40079'
});

// Authentication
const auth = getAuth();

// Sign up handler
export const signUp = (email: string, password: string) =>
	createUserWithEmailAndPassword(auth, email, password);

// Sign in handler
export const signIn = (email: string, password: string) =>
	signInWithEmailAndPassword(auth, email, password);

// Sign out handler
export const signOut = () => authSignOut(auth);

// Subscribe to auth state changes
export const onAuthChanged = (callback: (u: User | null) => void) =>
	onAuthStateChanged(auth, callback);

// Firestore
const db = getFirestore();

// Reviews collection
export type Review = {
	by: string;
	stars: number;
	description?: string;
};

// Tasks collection
export type Task = {
	id: string; // same as document id
	email: string; // user email
	name: string;
	description?: string;
	duration: number; // in minutes
	deadline: Timestamp;
	color: string; // hex color
	status: Status;
	category: string; // category name
};

// Categories collection
export type Category = {
	id: string; // same as document id
	email: string; // user email
	name: string;
	duration: number; // in minutes
	color: string; // hex color
};

export const reviewsCollection = collection(
	db,
	'reviews'
) as CollectionReference<Review>;

export const tasksCollection = collection(
	db,
	'tasks'
) as CollectionReference<Task>;

export const categoriesCollection = collection(
	db,
	'categories'
) as CollectionReference<Category>;

export const reviewsDocument = (id: string) =>
	doc(db, 'reviews', id) as DocumentReference<Review>;

export const tasksDocument = (id: string) =>
	doc(db, 'tasks', id) as DocumentReference<Task>;

export const categoriesDocument = (id: string) =>
	doc(db, 'categories', id) as DocumentReference<Category>;
