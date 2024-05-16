import {
	Button,
	FormControl,
	Grid,
	InputLabel,
	MenuItem,
	Select
} from '@mui/material';
import { FC, PropsWithChildren, useContext } from 'react';
import { updateDoc } from 'firebase/firestore';

import { Task, tasksDocument } from '../firebase';
import { ModeContext } from '../hooks/Context';
import { CalendarIcon, TimeIcon } from '../assets/Icons';

import { Status, statuses } from './TaskStatus';
import CalculateDuration from './CalculateDuration';

type Props = PropsWithChildren<{
	task: Task;
	onClick?: () => void;
}>;

const TaskPreview: FC<Props> = ({ task, onClick }) => {
	const handleSubmit = async (event: { target: { value: string } }) => {
		await updateDoc(tasksDocument(task.id), {
			status: event.target.value as Status
		});
	};
	const { calcDuration, calcUnit } = CalculateDuration(task.duration, true);
	const { mode } = useContext(ModeContext);

	return (
		<Grid item xs={2} sm={4} md={4} lg={4}>
			<Button
				variant="outlined"
				onClick={onClick}
				sx={{
					color: task.color,
					aspectRatio: '1',
					width: '100%',
					display: 'flex',
					flexDirection: 'column',
					flex: '1, 1, 0%'
				}}
			>
				<div className="flex items-center justify-between mb-2">
					<span className="block font-medium dark:text-slate-200">
						{task.name}
					</span>
				</div>
				<p
					title={task.description}
					className="description mb-2 text-slate-500 dark:text-slate-500 line-clamp-3"
					style={{ visibility: task.description !== '' ? 'visible' : 'hidden' }}
				>
					{task.description !== '' ? task.description : 'empty'}
				</p>
				<time className="p-3 sm:p-4 flex text-left">
					<CalendarIcon
						className="mr-2 w-4 sm:w-5 h-min"
						fill={mode === 'light' ? '#000000' : '#FFFFFF'}
					/>{' '}
					{task.deadline.toDate().getDate().toString().padStart(2, '0')}/
					{(task.deadline.toDate().getMonth() + 1).toString().padStart(2, '0')}/
					{task.deadline.toDate().getFullYear()}
				</time>
				<p className="flex">
					<TimeIcon
						className="mr-2 w-4 sm:w-5 h-min"
						stroke={mode === 'light' ? '#000000' : '#FFFFFF'}
					/>
					{calcDuration}
					{calcUnit}
				</p>
				<FormControl fullWidth>
					<InputLabel id="status-select-label">Status</InputLabel>
					<Select
						labelId="status-select-label"
						id="status-select"
						value={task.status}
						label="Status"
						onChange={handleSubmit}
						onClick={event => event.stopPropagation()}
						sx={{
							fontSize: '1rem',
							fontStyle: 'italic',
							textTransform: 'capitalize'
						}}
					>
						{statuses.map(status => (
							<MenuItem
								key={status}
								value={status}
								sx={{
									fontSize: '1rem',
									fontStyle: 'italic',
									textTransform: 'capitalize'
								}}
							>
								{status}
							</MenuItem>
						))}
					</Select>
				</FormControl>
			</Button>
		</Grid>
	);
};

export default TaskPreview;
