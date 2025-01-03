## QBX Staff Functions

The following functions are available for managing staff groups and duties in the QBX Staff system:

### `exports.qbx_staff:getGroup(source)`
- **Description**: Retrieves the group of a given player.
- **Parameters**: 
  - `source` (Player identifier)
- **Returns**: The player's current group.

### `exports.qbx_staff:checkExistence(source)`
- **Description**: Checks if the player exists in the system.
- **Parameters**: 
  - `source` (Player identifier)
- **Returns**: Boolean value indicating if the player exists.

### `exports.qbx_staff:setGroup(source, newGroup)`
- **Description**: Sets the player's group to a new group.
- **Parameters**: 
  - `source` (Player identifier)
  - `newGroup` (The new group name to assign)
- **Returns**: None.

### `exports.qbx_staff:ToggleDuty(source, boolean)`
- **Description**: Toggles the player's duty status.
- **Parameters**: 
  - `source` (Player identifier)
  - `boolean` (True to set the player on duty, False to set them off duty)
- **Returns**: None.

### `exports.qbx_staff:DutyState(source, type)`
- **Description**: Sets the player's duty state.
- **Parameters**:
  - `source` (Player identifier)
  - `type` (The type of duty, e.g., `aduty` or `hidden duty`)
- **Returns**: None.

### `exports.qbx_staff:checkDuty(source)`
- **Description**: Checks if the player is on any duty (aduty or hidden duty).
- **Parameters**: 
  - `source` (Player identifier)
- **Returns**: Boolean value indicating whether the player is on duty.
