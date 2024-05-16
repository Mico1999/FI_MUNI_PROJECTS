import React, { FC, PropsWithChildren, useState } from 'react';
type Mode = 'light' | 'dark';
type ModeContext = { mode: Mode; toggleMode: () => void };

export const ModeContext = React.createContext<ModeContext>({} as ModeContext);

export const ModeProvider: FC<PropsWithChildren> = ({ children }) => {
	const [mode, setMode] = useState<Mode>('light');
	const toggleMode = () => {
		setMode(mode === 'light' ? 'dark' : 'light');
	};

	return (
		<ModeContext.Provider value={{ mode, toggleMode }}>
			{children}
		</ModeContext.Provider>
	);
};
