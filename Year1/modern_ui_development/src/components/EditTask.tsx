import { ReactNode } from 'react';

import { Task } from '../firebase';

import AddTask from './AddTask';

type Props = {
	children: (open: () => void) => ReactNode;
	task: Task;
};
const EditTask = ({ children, task }: Props) => (
	// eslint-disable-next-line react/no-children-prop
	<AddTask children={children} task={task} />
);

export default EditTask;
