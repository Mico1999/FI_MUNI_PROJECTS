export const statuses = ['Planned', 'In progress', 'Finished'] as const;
export type Status = (typeof statuses)[number];
