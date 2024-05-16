import { Typography } from '@mui/material';

import usePageTitle from '../hooks/usePageTitle';

const About = () => {
	usePageTitle('About');
	return (
		<>
			<Typography variant="h2">TODO APP</Typography>
			<Typography sx={{ my: 10 }}>
				TODO APP is a simple web app which enables it&apos;s users to create,
				list, update, delete and filter their TODO tasks. Users have to be
				registered into system to make these actions. Each TODO task is
				described by it&apos;s name, desciption, duration, deadline, status
				(planned, in progress, finished) and category. Category describes task
				little bit more with it&apos;s name (shopping, school...), default
				duration and color (something like colorful papersticks on walls). Some
				categories like school, workout, shopping already exists in app, but
				users can create their own default categories used for creating new
				tasks. Users also can filter in list of their tasks on various criteria
				(task&apos;s status, category, progress ...). App also enables switching
				between two modes, light and dark.
			</Typography>
			<footer>
				Created by Marek Miček & Peter Rúček, all rights reserved.
			</footer>
		</>
	);
};
export default About;
