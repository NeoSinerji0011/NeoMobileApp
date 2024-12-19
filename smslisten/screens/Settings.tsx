import React, {useEffect, useLayoutEffect, useState} from 'react';
import {Container, TextInput} from '../components';
import RNSimData from 'react-native-sim-data';
import {handleSmsPermissionAndroid} from '../helpers/HelperPermission';
import {
  Alert,
  NativeModules,
  PermissionsAndroid,
  Pressable,
} from 'react-native';
import Feather from 'react-native-vector-icons/Feather';
import {perfectSize} from '../styles/spacing';
import {Colors} from '../styles';
const {SharedPrefenceModule} = NativeModules;

export default ({navigation}) => {
  const [phoneNumber, setPhoneNumber] = useState('');
  const [loaded, setLoaded] = useState(false);

  useLayoutEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <Pressable onPress={save} disabled={!loaded}>
          <Feather
            name="save"
            size={perfectSize(25)}
            color={loaded ? Colors.BLACK : Colors.GRAY_GRAY_1}
          />
        </Pressable>
      ),
    });
  }, [navigation, loaded, phoneNumber]);

  useEffect(() => {
    (async () => {
      try {
        await handleSmsPermissionAndroid(
          PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE,
        );
        const tempPhone = RNSimData.getTelephoneNumber();
        const dbPhone = await SharedPrefenceModule.get('neo_phoneNumber');
        setPhoneNumber(dbPhone);
        if (tempPhone && !dbPhone) {
          Alert.alert(
            '',
            `Telefon numarası tespit ettik. '${tempPhone}' telefon numarasını kullanmak ister misiniz?`,
            [
              {
                text: 'Evet',
                onPress: async () => {
                  await SharedPrefenceModule.set('neo_phoneNumber', tempPhone);
                  setPhoneNumber(
                    tempPhone
                      .replace(/\s/g, '')
                      .replace('+9', '')
                      .replace('+1', ''),
                  );
                },
              },
              {
                text: 'Hayır',
                style: 'cancel',
              },
            ],
          );
        }
      } finally {
        setLoaded(true);
      }
    })();
  }, []);

  const save = async () => {
    await SharedPrefenceModule.set('neo_phoneNumber', phoneNumber);
    Alert.alert('', 'Telefon numarası kaydedildi');
  };

  return (
    <Container>
      <TextInput
        placeholder="Telefon numarası"
        value={phoneNumber}
        maxLength={11}
        onChangeText={e => {
          console.log(e);
          setPhoneNumber(e);
        }}
      />
    </Container>
  );
};
