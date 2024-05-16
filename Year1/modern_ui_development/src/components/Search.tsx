import { TextField } from '@mui/material';
import { useContext } from 'react';

import { ModeContext } from '../hooks/Context';
import { SearchIcon } from '../assets/Icons';

export const Search = ({
	value,
	onChange
}: {
	value: string;
	onChange: React.ChangeEventHandler;
}) => {
	const { mode } = useContext(ModeContext);
	return (
		<TextField
			label="Search"
			className="w-full px-4 py-2 text-gray-700 rounded border-2 focus:outline-none
         focus:ring-2 focus:ring-purple-800 input flex-1"
			type="text"
			onChange={onChange}
			placeholder="Search by name ..."
			InputProps={{
				startAdornment: (
					<SearchIcon
						className="mr-2 w-10 h-min p-2"
						stroke={mode === 'light' ? '#000000' : '#FFFFFF'}
						fill={mode === 'light' ? '#FFFFFF' : '#000000'}
					/>
				)
			}}
			value={value}
		/>
	);
};
