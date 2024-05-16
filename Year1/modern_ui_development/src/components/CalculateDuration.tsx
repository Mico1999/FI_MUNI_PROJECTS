const CalculateDuration = (duration: number, isPrint?: boolean) => {
	const calcDuration =
		duration > 60 * 24
			? duration / (60 * 24)
			: duration > 60
			? duration / 60
			: duration;
	let calcUnit;
	if (isPrint) {
		calcUnit =
			duration > 60 * 24 ? ' Days' : duration > 60 ? ' Hours' : ' Mins';
	} else {
		calcUnit = duration > 60 * 24 ? 'days' : duration > 60 ? 'hours' : 'mins';
	}

	return {
		calcDuration,
		calcUnit
	};
};

export default CalculateDuration;
