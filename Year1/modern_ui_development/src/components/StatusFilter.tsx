import { Button } from '@mui/material';

const capitalize = (str: string) =>
	str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();

const StatusFilter = ({
	title,
	isActive,
	onClick
}: {
	title: string;
	isActive: boolean;
	onClick: React.MouseEventHandler;
}) => (
	<Button
		className="flex items-center justify-center w-1/3 h-20"
		onClick={onClick}
		sx={{
			marginTop: '1rem',
			color: isActive ? 'white' : '',
			backgroundColor: isActive ? '#8c1aff' : ''
		}}
	>
		<h3 className="text-left">{capitalize(title)}</h3>
	</Button>
);

export default StatusFilter;
