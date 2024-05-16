import { Button, Grid } from '@mui/material';
import { FC, PropsWithChildren, useContext } from 'react';

import { Category } from '../firebase';
import { ModeContext } from '../hooks/Context';
import { TimeIcon } from '../assets/Icons';

import CalculateDuration from './CalculateDuration';

type Props = PropsWithChildren<{
	category: Category;
	onClick?: () => void;
}>;

const CategoryPreview: FC<Props> = ({ category, onClick }) => {
	const { calcDuration, calcUnit } = CalculateDuration(category.duration, true);
	const { mode } = useContext(ModeContext);
	return (
		<Grid item xs={2} sm={4} md={4} lg={4}>
			<Button
				variant="outlined"
				onClick={onClick}
				sx={{
					color: category.color,
					aspectRatio: '1',
					width: '100%',
					display: 'flex',
					flexDirection: 'column',
					flex: '1, 1, 0%'
				}}
			>
				<div className="flex items-center justify-between mb-2">
					<span className="block font-medium dark:text-slate-200">
						{category.name}
					</span>
				</div>
				<p className="flex">
					<TimeIcon
						className="mr-2 w-4 sm:w-5 h-min"
						stroke={mode === 'light' ? '#000000' : '#FFFFFF'}
					/>
					{calcDuration}
					{calcUnit}
				</p>
			</Button>
		</Grid>
	);
};

export default CategoryPreview;
