import { Button, Grid } from '@mui/material';
import { FC } from 'react';

import { Category } from '../firebase';
import useLoggedInUser from '../hooks/useLoggedInUser';

import AddCategory from './AddCategory';
import EditCategory from './EditCategory';
import CategoryPreview from './CategoryPreview';

type Props = {
	categories: Category[];
};

const CategoryGrid: FC<Props> = ({ categories }) => {
	const user = useLoggedInUser();

	return (
		<Grid
			container
			spacing={{ xs: 2, md: 3, lg: 4 }}
			columns={{ xs: 4, sm: 8, md: 12, lg: 16 }}
		>
			{categories.map((category, i) => {
				// show only categories of login user
				if (category.email === user?.email) {
					return (
						<EditCategory key={i} category={category}>
							{open => (
								<CategoryPreview key={i} category={category} onClick={open} />
							)}
						</EditCategory>
					);
				}
			})}
			<Grid item xs={2} sm={4} md={4} lg={4}>
				<AddCategory>
					{open => (
						<Button
							onClick={open}
							variant="contained"
							sx={{
								aspectRatio: '1',
								width: '100%'
							}}
						>
							Add Category
						</Button>
					)}
				</AddCategory>
			</Grid>
		</Grid>
	);
};

export default CategoryGrid;
