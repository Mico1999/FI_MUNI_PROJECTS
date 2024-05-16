import { useEffect } from 'react';

const usePageTitle = (title: string) => {
	useEffect(() => {
		document.title = `${title} | TODO App`;
	}, [title]);
};

export default usePageTitle;
