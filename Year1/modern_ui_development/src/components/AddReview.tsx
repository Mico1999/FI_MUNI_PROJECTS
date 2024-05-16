import { Star, StarBorder } from '@mui/icons-material';
import {
	Box,
	Button,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	IconButton,
	TextField,
	Typography
} from '@mui/material';
import { ReactNode, useState } from 'react';
import { setDoc } from 'firebase/firestore';

import useField from '../hooks/useField';
import { reviewsDocument } from '../firebase';
import useLoggedInUser from '../hooks/useLoggedInUser';

type Props = {
	children: (open: () => void) => ReactNode;
};

const AddReview = ({ children }: Props) => {
	const user = useLoggedInUser();

	// Open state
	const [open, setOpen] = useState(false);

	// Fields
	const [stars, setStars] = useState(1);
	const description = useField('description');

	const [submitError, setSubmitError] = useState<string>();

	// Close and reset handler
	const closeDialog = () => {
		setOpen(false);
		setStars(0);
		description.props.onChange({ target: { value: '' } } as never);
		setSubmitError(undefined);
	};

	// Submit handler
	const handleSubmit = async () => {
		if (!user?.email) {
			setSubmitError('Sign in first to make review');
			return;
		}
		try {
			await setDoc(reviewsDocument(user.email), {
				by: user?.email ?? 'anon',
				stars,
				description: description.value
			});
			closeDialog();
		} catch (err) {
			setSubmitError(
				err instanceof Error ? err.message : 'Unknown error occurred'
			);
		}
	};

	return (
		<>
			{children(() => setOpen(true))}
			<Dialog open={open} onClose={closeDialog}>
				<DialogTitle>Add a review</DialogTitle>
				<DialogContent
					sx={{
						display: 'flex',
						flexDirection: 'column',
						gap: 2,
						minWidth: 500
					}}
				>
					{/* Stars select */}
					<Box>
						{[...Array(5).keys()].map(i => (
							<IconButton
								key={i}
								color="primary"
								component="span"
								onClick={() => setStars(i + 1)}
							>
								{i < stars ? <Star /> : <StarBorder />}
							</IconButton>
						))}
					</Box>
					<TextField label="Description" fullWidth {...description.props} />
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
				</DialogActions>
			</Dialog>
		</>
	);
};

export default AddReview;
