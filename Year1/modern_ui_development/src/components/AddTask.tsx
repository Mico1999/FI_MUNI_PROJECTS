import { ReactNode, SetStateAction, useEffect, useState } from 'react';
import {
	deleteDoc,
	onSnapshot,
	setDoc,
	Timestamp,
	updateDoc
} from 'firebase/firestore';
import { v4 as uuidv4 } from 'uuid';
import { CirclePicker } from 'react-color';
import { DatePicker } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import {
	Button,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	FormControl,
	IconButton,
	InputLabel,
	MenuItem,
	Select,
	TextField,
	Typography
} from '@mui/material';
import dayjs, { Dayjs } from 'dayjs';
import 'dayjs/locale/en-gb';
import { Delete } from '@mui/icons-material';

import useLoggedInUser from '../hooks/useLoggedInUser';
import {
	Category,
	Task,
	categoriesCollection,
	tasksDocument
} from '../firebase';

import CalculateDuration from './CalculateDuration';

type Props = {
	children: (open: () => void) => ReactNode;
	task?: Task;
};

const AddTask = ({ children, task }: Props) => {
	const user = useLoggedInUser();
	// Open state
	const [open, setOpen] = useState(false);

	// Fields
	const [name, setName] = useState('');
	const [description, setDescription] = useState('');
	const [deadline, setDeadline] = useState<Dayjs | null>(dayjs());
	const [duration, setDuration] = useState(10);
	const [unit, setUnit] = useState('mins');
	const units = ['mins', 'hours', 'days'];
	const [color, setColor] = useState('#F44336');
	const [category, setCategory] = useState('');
	// user categories
	const [userCategories, setUserCategories] = useState<Category[]>([]);

	useEffect(() => {
		if (task) {
			setName(task.name);
			setDescription(task.description !== undefined ? task.description : '');
			setDeadline(dayjs(task.deadline.toDate()));
			const { calcDuration, calcUnit } = CalculateDuration(task.duration);
			setDuration(calcDuration);
			setUnit(calcUnit);
			setColor(task.color);
			setCategory(task.category);
		}
	}, [task, open]);

	useEffect(
		() =>
			onSnapshot(categoriesCollection, snapshot => {
				setUserCategories(snapshot.docs.map(doc => doc.data()));
			}),
		[]
	);

	const [submitError, setSubmitError] = useState<string>();

	// Close and reset handler
	const closeDialog = () => {
		setOpen(false);
		setName('');
		setDescription('');
		setDeadline(dayjs());
		setDuration(10);
		setUnit('mins');
		setColor('#F44336');
		setCategory('');
		setSubmitError(undefined);
	};

	// Submit handler
	const handleSubmit = async () => {
		if (!user?.email) {
			setSubmitError('Sign in first to create task');
			return;
		}
		if (name === '') {
			setSubmitError('Name of task is required');
			return;
		}
		try {
			if (task) {
				await updateDoc(tasksDocument(task.id), {
					name,
					description,
					duration:
						duration * (unit === 'mins' ? 1 : unit === 'hours' ? 60 : 60 * 24),
					deadline: Timestamp.fromDate(
						deadline ? deadline.toDate() : new Date()
					),
					color,
					category
				});
			} else {
				const id = uuidv4();
				await setDoc(tasksDocument(id), {
					id,
					email: user.email,
					name,
					description,
					duration:
						duration * (unit === 'mins' ? 1 : unit === 'hours' ? 60 : 60 * 24),
					deadline: Timestamp.fromDate(
						deadline ? deadline.toDate() : new Date()
					),
					status: 'Planned',
					color,
					category
				});
			}

			closeDialog();
		} catch (err) {
			setSubmitError(
				err instanceof Error ? err.message : 'Unknown error occurred'
			);
		}
	};

	const handleChangeComplete = (color: { hex: SetStateAction<string> }) => {
		setColor(color.hex);
	};

	const handleNumberChange = (event: { target: { value: string } }) => {
		const re = /^[0-9\b]+$/;
		if (event.target.value === '' || re.test(event.target.value)) {
			setDuration(+event.target.value);
		}
	};

	const handleCategoryChange = (event: { target: { value: string } }) => {
		const newCategoryName = event.target.value;
		setCategory(newCategoryName);

		// set task duration and color according to selected category
		userCategories.forEach(userCategory => {
			if (
				userCategory.email === user?.email &&
				userCategory.name === newCategoryName
			) {
				const { calcDuration, calcUnit } = CalculateDuration(
					userCategory.duration
				);
				setDuration(calcDuration);
				setUnit(calcUnit);
				setColor(userCategory.color);
			}
		});
	};

	const handleDeleteTask = async () => {
		task && (await deleteDoc(tasksDocument(task.id)));
		closeDialog();
	};

	return (
		<>
			{children(() => setOpen(true))}
			<Dialog open={open} onClose={closeDialog}>
				{task ? (
					<DialogTitle>Edit task</DialogTitle>
				) : (
					<DialogTitle>Add task</DialogTitle>
				)}

				<DialogContent
					sx={{
						display: 'flex',
						flexDirection: 'column',
						gap: 2,
						minWidth: 500
					}}
				>
					<TextField
						label="Name"
						fullWidth
						value={name}
						required
						onChange={event => {
							setName(event.target.value);
						}}
					/>
					<TextField
						label="Description"
						fullWidth
						value={description}
						onChange={event => {
							setDescription(event.target.value);
						}}
					/>

					<FormControl fullWidth>
						<InputLabel id="category-select-label">Category</InputLabel>
						<Select
							labelId="category-select-label"
							id="category-select"
							value={category}
							label="Category"
							onChange={handleCategoryChange}
							sx={{
								fontSize: '1rem',
								fontStyle: 'italic',
								textTransform: 'capitalize'
							}}
						>
							{userCategories.map(userCategory => {
								// shows only categories of login user
								if (userCategory.email === user?.email) {
									return (
										<MenuItem
											key={userCategory.id}
											value={userCategory.name}
											sx={{
												fontSize: '1rem',
												fontStyle: 'italic',
												textTransform: 'capitalize'
											}}
										>
											{userCategory.name}
										</MenuItem>
									);
								}
							})}
						</Select>
					</FormControl>

					<LocalizationProvider
						dateAdapter={AdapterDayjs}
						adapterLocale="en-gb"
					>
						<DatePicker value={deadline} onChange={date => setDeadline(date)} />
					</LocalizationProvider>

					<div className="flex flex-row w-full">
						<TextField
							label="Duration"
							sx={{
								width: '75%'
							}}
							type="number"
							value={duration}
							onChange={handleNumberChange}
						/>
						<FormControl sx={{ width: '25%' }}>
							<InputLabel id="unit-select-label">Unit</InputLabel>
							<Select
								labelId="unit-select-label"
								id="unit-select"
								value={unit}
								defaultValue="mins"
								label="Units"
								onChange={event => {
									setUnit(event.target.value);
								}}
								sx={{
									fontSize: '1rem',
									fontStyle: 'italic',
									textTransform: 'capitalize'
								}}
							>
								{units.map(_unit => (
									<MenuItem
										key={_unit}
										value={_unit}
										sx={{
											fontSize: '1rem',
											fontStyle: 'italic',
											textTransform: 'capitalize'
										}}
									>
										{_unit}
									</MenuItem>
								))}
							</Select>
						</FormControl>
					</div>
					<div className="colorPicker">
						<CirclePicker
							color={color}
							onChange={handleChangeComplete}
							onChangeComplete={handleChangeComplete}
						/>
					</div>
				</DialogContent>
				<DialogActions>
					{submitError && (
						<Typography
							variant="subtitle2"
							align="left"
							color="error"
							paragraph
							sx={{ mb: 0, mr: 2 }}
						>
							{submitError}
						</Typography>
					)}
					<Button onClick={closeDialog} variant="outlined">
						Cancel
					</Button>
					<Button onClick={handleSubmit} variant="contained">
						Submit
					</Button>
					{task && (
						<IconButton color="error" title="Delete" onClick={handleDeleteTask}>
							<Delete />
						</IconButton>
					)}
				</DialogActions>
			</Dialog>
		</>
	);
};

export default AddTask;
