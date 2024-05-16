import { Delete, Star, StarBorder } from '@mui/icons-material';
import {
	Box,
	Card,
	CardActions,
	CardContent,
	IconButton,
	Typography
} from '@mui/material';
import { deleteDoc } from '@firebase/firestore';

import { Review, reviewsDocument } from '../firebase';
import useLoggedInUser from '../hooks/useLoggedInUser';

const ReviewPreview = ({ by, stars, description }: Review) => {
	const user = useLoggedInUser();

	const handleDeleteReview = async () => {
		await deleteDoc(reviewsDocument(by));
	};

	return (
		<Card
			sx={{
				display: 'flex',
				flexDirection: 'column',
				justifyContent: 'space-between',
				width: '100%',
				textAlign: 'left'
			}}
		>
			<CardContent>
				<Typography variant="h5" color="textSecondary">
					{by}
				</Typography>
				<Box mb={2}>
					{[...Array(5).keys()].map(i =>
						i < stars ? (
							<Star key={i} color="primary" />
						) : (
							<StarBorder key={i} color="primary" />
						)
					)}
				</Box>
				{description && <Typography>{description}</Typography>}
			</CardContent>
			{user?.email === by && (
				<CardActions>
					<IconButton color="error" title="Delete" onClick={handleDeleteReview}>
						<Delete />
					</IconButton>
				</CardActions>
			)}
		</Card>
	);
};

export default ReviewPreview;
