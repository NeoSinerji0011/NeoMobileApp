import {
  PermissionsAndroid,
  Platform,
  PermissionStatus,
  Permission,
} from 'react-native';

const handleSmsPermissionAndroid = async (permission: Permission) => {
  let hasPermissions = false;
  if (Platform.OS === 'android') {
    try {
      hasPermissions = await checkSmsPermissions(permission);
      if (!hasPermissions) {
        hasPermissions = await requestSmsPermissions(permission);
      }
      return hasPermissions;
    } catch (e) {
      console.log(e);
      hasPermissions = false;
    } finally {
      return hasPermissions;
    }
  }

  return false;
};

const checkSmsPermissions = async (permission: Permission) => {
  let hasPermissions = false;
  try {
    hasPermissions = await PermissionsAndroid.check(permission);
  } catch (e) {
    console.log(e);
    hasPermissions = false;
  } finally {
    return hasPermissions;
  }
};

const requestSmsPermissions = async (permission: Permission) => {
  let granted: {[key: string]: PermissionStatus} = {};
  let hasPermissions: boolean | null = true;
  try {
    granted = await PermissionsAndroid.requestMultiple([permission]);
    Object.values(granted).forEach((result: PermissionStatus) => {
      if (
        result !== PermissionsAndroid.RESULTS.GRANTED &&
        hasPermissions !== null
      ) {
        hasPermissions = false;
      }
      if (result === PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN) {
        hasPermissions = null;
      }
    });
    if (hasPermissions) {
      console.log('You can use SMS features');
    } else {
      console.log('SMS permission denied');
    }
    console.log(hasPermissions, 'a');
    return hasPermissions;
  } catch (err) {
    console.log(err);
    return false;
  }
};

export {handleSmsPermissionAndroid, checkSmsPermissions, requestSmsPermissions};
