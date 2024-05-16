import { Button, Grid } from '@mui/material';
import { FC } from 'react';

import { Task } from '../firebase';
import useLoggedInUser from '../hooks/useLoggedInUser';

import TaskPreview from './TaskPreview';
import AddTask from './AddTask';
import EditTask from './EditTask';

type Props = {
	tasks: Task[];
};

const TaskGrid: FC<Props> = ({ tasks }) => {
	const user = useLoggedInUser();

	return (
		<Grid
			container
			spacing={{ xs: 2, md: 3, lg: 4 }}
			columns={{ xs: 4, sm: 8, md: 12, lg: 16 }}
		>
			{tasks.map((task, i) => {
				// show only tasks of login user
				if (task.email === user?.email) {
					return (
						<EditTask key={i} task={task}>
							{open => <TaskPreview key={i} task={task} onClick={open} />}
						</EditTask>
					);
				}
			})}
			<Grid item xs={2} sm={4} md={4} lg={4}>
				<AddTask>
					{open => (
						<Button
							onClick={open}
							variant="contained"
							sx={{
								aspectRatio: '1',
								width: '100%'
							}}
						>
							Add Task
						</Button>
					)}
				</AddTask>
			</Grid>
		</Grid>
	);
};

export default TaskGrid;
