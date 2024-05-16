import { ReactNode, SetStateAction, useEffect, useState } from 'react';
import { deleteDoc, getDocs, setDoc, updateDoc } from 'firebase/firestore';
import { v4 as uuidv4 } from 'uuid';
import { CirclePicker } from 'react-color';
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
import 'dayjs/locale/en-gb';
import { Delete } from '@mui/icons-material';

import useLoggedInUser from '../hooks/useLoggedInUser';
import {
	Category,
	categoriesDocument,
	tasksCollection,
	tasksDocument
} from '../firebase';

import CalculateDuration from './CalculateDuration';

type Props = {
	children: (open: () => void) => ReactNode;
	category?: Category;
};

const AddCategory = ({ children, category }: Props) => {
	const user = useLoggedInUser();
	// Open state
	const [open, setOpen] = useState(false);

	// Fields
	const [name, setName] = useState('');
	const [duration, setDuration] = useState(10);
	const [unit, setUnit] = useState('mins');
	const units = ['mins', 'hours', 'days'];
	const [color, setColor] = useState('#F44336');

	useEffect(() => {
		if (category) {
			setName(category.name);
			const { calcDuration, calcUnit } = CalculateDuration(category.duration);
			setDuration(calcDuration);
			setUnit(calcUnit);
			setColor(category.color);
		}
	}, [category, open]);

	const [submitError, setSubmitError] = useState<string>();

	// Close and reset handler
	const closeDialog = () => {
		setOpen(false);
		setName('');
		setDuration(10);
		setUnit('mins');
		setColor('#F44336');
		setSubmitError(undefined);
	};

	// Submit handler
	const handleSubmit = async () => {
		if (!user?.email) {
			setSubmitError('Sign in first to create category');
			return;
		}
		if (name === '') {
			setSubmitError('Name of category is required');
			return;
		}
		try {
			if (category) {
				await updateDoc(categoriesDocument(category.id), {
					name,
					duration:
						duration * (unit === 'mins' ? 1 : unit === 'hours' ? 60 : 60 * 24),
					color
				});

				// update tasks color with edited category..duration remains same in task, not using defualt
				const snapshot = await getDocs(tasksCollection);
				const allTasks = snapshot.docs.map(doc => doc.data());

				allTasks.forEach(async task => {
					if (task.category === category.name && task.email === user.email) {
						await updateDoc(tasksDocument(task.id), {
							category: name,
							color
						});
					}
				});
			} else {
				const id = uuidv4();
				await setDoc(categoriesDocument(id), {
					id,
					email: user.email,
					name,
					duration:
						duration * (unit === 'mins' ? 1 : unit === 'hours' ? 60 : 60 * 24),
					color
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

	const handleDeleteCategory = async () => {
		category && (await deleteDoc(categoriesDocument(category.id)));
		closeDialog();
	};

	return (
		<>
			{children(() => setOpen(true))}
			<Dialog open={open} onClose={closeDialog}>
				{category ? (
					<DialogTitle>Edit category</DialogTitle>
				) : (
					<DialogTitle>Add category</DialogTitle>
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
					<div className="flex flex-row w-full">
						<TextField
							label="Default duration"
							sx={{
								width: '75%'
							}}
							type="number"
							value={duration}
							required
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
					{category && (
						<IconButton
							color="error"
							title="Delete"
							onClick={handleDeleteCategory}
						>
							<Delete />
						</IconButton>
					)}
				</DialogActions>
			</Dialog>
		</>
	);
};

export default AddCategory;
