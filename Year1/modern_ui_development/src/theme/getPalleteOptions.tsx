import { PaletteMode } from '@mui/material';
import { deepPurple, pink } from '@mui/material/colors';

const getPalleteValues = (mode: PaletteMode) => ({
	palette: {
		mode,
		primary: deepPurple,
		secondary: pink,
		contrastText: '#000000'
	}
});

export default getPalleteValues;
