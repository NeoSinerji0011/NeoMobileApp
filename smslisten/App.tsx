import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {Provider} from 'mobx-react';
import React from 'react';
import {StatusBar} from 'react-native';
import {ScreenHome, ScreenLogin, ScreenSettings} from './screens';
import {UserStore} from './stores';
import {Colors} from './styles';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <Provider user={UserStore}>
      <StatusBar barStyle="dark-content" backgroundColor={Colors.WHITE} />
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen
            name="Home"
            component={ScreenHome}
            options={{
              title: 'Mesajlar',
            }}
          />
          <Stack.Screen
            name="Settings"
            options={{
              title: 'Ayarlar',
            }}
            component={ScreenSettings}
          />
          <Stack.Screen
            name="Login"
            options={{
              headerShown: false,
            }}
            component={ScreenLogin}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </Provider>
  );
};

export default App;
