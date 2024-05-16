import { ReactNode } from 'react';

import { Category } from '../firebase';

import AddCategory from './AddCategory';

type Props = {
	children: (open: () => void) => ReactNode;
	category: Category;
};
const EditCategory = ({ children, category }: Props) => (
	// eslint-disable-next-line react/no-children-prop
	<AddCategory children={children} category={category} />
);

export default EditCategory;
