import { useNavigate } from '@tanstack/react-router';
import { FormEvent, useEffect, useState } from 'react';
import { Box, Button, Paper, TextField, Typography } from '@mui/material';
import { setDoc } from 'firebase/firestore';
import { v4 as uuidv4 } from 'uuid';

import usePageTitle from '../hooks/usePageTitle';
import useField from '../hooks/useField';
import { categoriesDocument, signIn, signUp } from '../firebase';

const Login = () => {
	usePageTitle('Login');

	const navigate = useNavigate();

	const [isSignUp, setSignUp] = useState(false);

	const email = useField('email', true);
	const password = useField('password', true);

	const [submitError, setSubmitError] = useState<string>();

	const defaultCategoryDict: {
		[categoryName: string]: { duration: number; color: string };
	} = {};

	defaultCategoryDict.School = { duration: 600, color: '#f44336' };
	defaultCategoryDict.Work = { duration: 480, color: '#ffeb3b' };
	defaultCategoryDict.Shopping = { duration: 30, color: '#4caf50' };

	useEffect(() => {
		if (isSignUp) {
			// add default categories school, work, shopping to newly registerred user
			Object.entries(defaultCategoryDict).forEach(async ([key, value]) => {
				const id = uuidv4();
				await setDoc(categoriesDocument(id), {
					id,
					email: email.value,
					name: key,
					duration: value.duration,
					color: value.color
				});
			});
		}
	}, [isSignUp]);

	return (
		<Paper
			component="form"
			onSubmit={async (e: FormEvent) => {
				e.preventDefault();
				try {
					isSignUp
						? await signUp(email.value, password.value)
						: await signIn(email.value, password.value);
					navigate({ to: '/' });
				} catch (err) {
					setSubmitError(
						(err as { message?: string })?.message ?? 'Unknown error occurred'
					);
				}
			}}
			sx={{
				display: 'flex',
				flexDirection: 'column',
				width: '100%',
				p: 4,
				gap: 2
			}}
		>
			<Typography variant="h4" component="h2" textAlign="center" mb={3}>
				Login
			</Typography>
			<TextField label="email" {...email.props} type="email" />
			<TextField label="password" {...password.props} type="password" />
			<Box
				sx={{
					display: 'flex',
					gap: 2,
					alignItems: 'center',
					alignSelf: 'flex-end',
					mt: 2
				}}
			>
				{submitError && (
					<Typography
						variant="caption"
						textAlign="right"
						sx={{ color: 'error.main' }}
					>
						{submitError}
					</Typography>
				)}
				<Button
					type="submit"
					variant="outlined"
					onClick={() => setSignUp(true)}
				>
					SIGN UP
				</Button>
				<Button
					type="submit"
					variant="contained"
					onClick={() => setSignUp(false)}
				>
					SIGN IN
				</Button>
			</Box>
		</Paper>
	);
};

export default Login;
