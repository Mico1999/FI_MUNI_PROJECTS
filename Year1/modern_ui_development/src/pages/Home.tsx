import { useContext, useEffect, useState } from 'react';
import { onSnapshot } from 'firebase/firestore';
import { Box, Button, Tab } from '@mui/material';
import { TabContext, TabList, TabPanel } from '@mui/lab';
import { DatePicker } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { Dayjs } from 'dayjs';

import usePageTitle from '../hooks/usePageTitle';
import {
	Category,
	Task,
	categoriesCollection,
	tasksCollection
} from '../firebase';
import TaskGrid from '../components/TaskGrid';
import CategoryGrid from '../components/CategoryGrid';
import { Search } from '../components/Search';
import { statuses } from '../components/TaskStatus';
import StatusFilter from '../components/StatusFilter';
import 'dayjs/locale/en-gb';
import { ModeContext } from '../hooks/Context';
import { FilterIcon } from '../assets/Icons';

const Home = () => {
	usePageTitle('Home');

	const [tabValue, setTabValue] = useState('1');
	const [tasks, setTasks] = useState<Task[]>([]);
	const [categories, setCategories] = useState<Category[]>([]);
	const [inputValue, setInputValue] = useState('');
	const [activeFilter, setActiveFilter] = useState('');
	const [fromFilter, setFromFilter] = useState<Dayjs | null>(null);
	const [toFilter, setToFilter] = useState<Dayjs | null>(null);
	const [isFilter, setIsFilter] = useState(false);
	const { mode } = useContext(ModeContext);

	useEffect(
		() =>
			onSnapshot(tasksCollection, snapshot => {
				setTasks(snapshot.docs.map(doc => doc.data()));
			}),
		[]
	);

	useEffect(
		() =>
			onSnapshot(categoriesCollection, snapshot => {
				setCategories(snapshot.docs.map(doc => doc.data()));
			}),
		[]
	);

	const handleTabChange = (_event: React.SyntheticEvent, newValue: string) => {
		setTabValue(newValue);
	};

	return (
		<Box sx={{ width: '100%', typography: 'body1' }}>
			<TabContext value={tabValue}>
				<Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
					<TabList onChange={handleTabChange} aria-label="lab API tabs example">
						<Tab label="Tasks" value="1" />
						<Tab label="Categories" value="2" />
					</TabList>
				</Box>
				{tabValue === '1' &&
					statuses.map((status, index) => (
						<StatusFilter
							key={index}
							title={status}
							isActive={status === activeFilter}
							onClick={(e: React.MouseEvent) => {
								const el = e.target as HTMLElement;
								el.textContent === activeFilter
									? (setActiveFilter(''), setIsFilter(false))
									: (setActiveFilter(status), setIsFilter(true));
							}}
						/>
					))}
				<div className="flex mt-6">
					<Search
						value={inputValue}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
							setIsFilter(true);
							if (e.target.value === '') {
								setIsFilter(false);
							}
							setInputValue(e.target.value);
						}}
					/>
					{tabValue === '1' && (
						<div>
							<LocalizationProvider
								dateAdapter={AdapterDayjs}
								adapterLocale="en-gb"
							>
								<DatePicker
									label="From"
									value={fromFilter}
									onChange={date => {
										setFromFilter(date);
										setIsFilter(true);
									}}
								/>
							</LocalizationProvider>
							<LocalizationProvider
								dateAdapter={AdapterDayjs}
								adapterLocale="en-gb"
							>
								<DatePicker
									label="To"
									value={toFilter}
									onChange={date => {
										setToFilter(date);
										setIsFilter(true);
									}}
								/>
							</LocalizationProvider>
						</div>
					)}

					<Button
						sx={{ bgcolor: isFilter ? '#8c1aff' : '' }}
						disabled={!isFilter}
						onClick={_e => {
							setActiveFilter('');
							setFromFilter(null);
							setToFilter(null);
							setInputValue('');
							setIsFilter(false);
						}}
					>
						<FilterIcon
							className="w-4 sm:w-5 h-min"
							stroke={mode === 'light' ? '#000000' : '#FFFFFF'}
						/>
					</Button>
				</div>

				<TabPanel value="1">
					<TaskGrid
						tasks={tasks
							.filter(el =>
								el.name.toLowerCase().includes(inputValue.toLowerCase())
							)
							.filter(e => e.status.includes(activeFilter))
							.filter(
								e =>
									e.deadline.toDate() >=
									(fromFilter === null
										? e.deadline.toDate()
										: fromFilter.toDate())
							)
							.filter(
								e =>
									e.deadline.toDate() <=
									(toFilter === null ? e.deadline.toDate() : toFilter.toDate())
							)}
					/>
				</TabPanel>
				<TabPanel value="2">
					<CategoryGrid
						categories={categories.filter(el =>
							el.name.toLowerCase().includes(inputValue.toLowerCase())
						)}
					/>
				</TabPanel>
			</TabContext>
		</Box>
	);
};
export default Home;
