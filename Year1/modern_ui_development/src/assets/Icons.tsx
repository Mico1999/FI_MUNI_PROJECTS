import { FC } from 'react';

type Props = {
	className?: string;
	fill?: string;
	stroke?: string;
};

export const SearchIcon: FC<Props> = ({ className, fill, stroke }) => (
	<svg
		className={className}
		width="800px"
		height="800px"
		viewBox="0 0 24 24"
		fill={fill}
		stroke={stroke}
		xmlns="http://www.w3.org/2000/svg"
	>
		<g id="Interface / Search_Magnifying_Glass">
			<path
				id="Vector"
				d="M15 15L21 21M10 17C6.13401 17 3 13.866 3 10C3 6.13401 6.13401 3 10 3C13.866 3 17 6.13401 17 10C17 13.866 13.866 17 10 17Z"
				stroke={stroke}
				strokeWidth="2"
				strokeLinecap="round"
				strokeLinejoin="round"
			/>
		</g>
	</svg>
);

export const TimeIcon: FC<Props> = ({ className, stroke }) => (
	<svg
		className={className}
		width="800px"
		height="800px"
		viewBox="0 0 24 24"
		fill="none"
		stroke={stroke}
		xmlns="http://www.w3.org/2000/svg"
	>
		<path
			d="M12 8V12L15 15"
			stroke={stroke}
			strokeWidth="2"
			strokeLinecap="round"
		/>
		<circle cx="12" cy="12" r="9" stroke={stroke} strokeWidth="2" />
	</svg>
);

export const CalendarIcon: FC<Props> = ({ className, fill }) => (
	<svg
		className={className}
		width="800px"
		height="800px"
		viewBox="0 0 20 20"
		version="1.1"
		xmlns="http://www.w3.org/2000/svg"
		xmlnsXlink="http://www.w3.org/1999/xlink"
	>
		<title>calendar [#1322]</title>
		<desc>Created with Sketch.</desc>
		<defs />
		<g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
			<g
				id="Dribbble-Light-Preview"
				transform="translate(-60.000000, -2319.000000)"
				fill={fill}
			>
				<g id="icons" transform="translate(56.000000, 160.000000)">
					<path
						d="M21.971246,2167 L5.99680511,2167 L5.99680511,2163.971 C5.99680511,2163.435 6.43111022,2163 6.96625399,2163 L7.99361022,2163 L7.99361022,2165 L9.99041534,2165 L9.99041534,2163 L17.9776358,2163 L17.9776358,2165 L19.9744409,2165 L19.9744409,2163 L20.9728435,2163 C21.5239617,2163 21.971246,2163.448 21.971246,2164 L21.971246,2167 Z M21.971246,2176 C21.971246,2176.55 21.5219649,2177 20.9728435,2177 L6.99520767,2177 C6.44408946,2177 5.99680511,2176.552 5.99680511,2176 L5.99680511,2169 L21.971246,2169 L21.971246,2176 Z M4.06389776,2176.761 C4.06389776,2177.865 5.02136581,2179 6.12360224,2179 L22.0980431,2179 C23.201278,2179 24,2177.979 24,2176.761 C24,2176.372 23.9680511,2164.36 23.9680511,2163.708 C23.9680511,2161.626 23.6875,2161 19.9744409,2161 L19.9744409,2159 L17.9776358,2159 L17.9776358,2161 L9.99041534,2161 L9.99041534,2159 L7.99361022,2159 L7.99361022,2161 L5.99680511,2161 C4.8985623,2161 4,2161.9 4,2163 L4.06389776,2176.761 Z"
						id="calendar-[#1322]"
					/>
				</g>
			</g>
		</g>
	</svg>
);

export const FilterIcon: FC<Props> = ({ className, stroke }) => (
	<svg
		className={className}
		width="800px"
		height="800px"
		viewBox="0 0 24 24"
		fill="none"
		xmlns="http://www.w3.org/2000/svg"
	>
		<g id="Interface / Filter">
			<path
				id="Vector"
				d="M20 5.6001C20 5.04005 19.9996 4.75981 19.8906 4.5459C19.7948 4.35774 19.6423 4.20487 19.4542 4.10899C19.2403 4 18.9597 4 18.3996 4H5.59961C5.03956 4 4.75981 4 4.5459 4.10899C4.35774 4.20487 4.20487 4.35774 4.10899 4.5459C4 4.75981 4 5.04005 4 5.6001V6.33736C4 6.58195 4 6.70433 4.02763 6.81942C4.05213 6.92146 4.09263 7.01893 4.14746 7.1084C4.20928 7.20928 4.29591 7.29591 4.46875 7.46875L9.53149 12.5315C9.70443 12.7044 9.79044 12.7904 9.85228 12.8914C9.90711 12.9808 9.94816 13.0786 9.97266 13.1807C10 13.2946 10 13.4155 10 13.6552V18.411C10 19.2682 10 19.6971 10.1805 19.9552C10.3382 20.1806 10.5814 20.331 10.8535 20.3712C11.1651 20.4172 11.5487 20.2257 12.3154 19.8424L13.1154 19.4424C13.4365 19.2819 13.5966 19.2013 13.7139 19.0815C13.8176 18.9756 13.897 18.8485 13.9453 18.7084C14 18.5499 14 18.37 14 18.011V13.6626C14 13.418 14 13.2958 14.0276 13.1807C14.0521 13.0786 14.0926 12.9808 14.1475 12.8914C14.2089 12.7911 14.2947 12.7053 14.4653 12.5347L14.4688 12.5315L19.5315 7.46875C19.7044 7.2958 19.7904 7.20932 19.8523 7.1084C19.9071 7.01893 19.9482 6.92146 19.9727 6.81942C20 6.70551 20 6.58444 20 6.3448V5.6001Z"
				stroke={stroke}
				strokeWidth="2"
				strokeLinecap="round"
				strokeLinejoin="round"
			/>
		</g>
	</svg>
);
