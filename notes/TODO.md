#### TODO

- [cancelled] One multi-line text box where you can enter one company + optional date range(s) per line:
    Acme Inc., 2007.10-2009.6
    Software Inc., 2009.7-2010.7, 2012.1-2014.8
- [cancelled] Possibly allow user to adjust bar graph directly, e.g. drag-and-drop to re-arrange bars, adjust their lengths, etc.
- [done] Add role to company (e.g. developer, manager, head nurse, etc.)
- Add achievements / what you did (e.g. analyzed data, wrote requirements doc, wrote conversion program, etc.)
- Only update the server every n seconds
- Horizontal bar graph that lists companies on the y-axis and a date range on the x-axis
- Combine 'start date' and 'end date' into 'when'
- Implement job add
- Implement job delete
- Highlight (e.g. yellow background) the currently edited row
- Implement undo/redo; persisted? what is the unit of undo? character level or field level?
- Do we need version control? i.e. what did you change last month?  How to decide where the version changes occur
- Feature to only show last e.g. ten years worth of data?
- Implement job duplicate? Or row cut/copy & paste?
- Design validation scheme: validate on client but should invalid data be stored in the db?
