import {
  Center,
  Flex,
  Inset,
  Row,
  Stack,
} from '@muratoner/semantic-ui-react-native';
import {inject, observer} from 'mobx-react';
import React, {useEffect, useLayoutEffect, useState} from 'react';
import {
  Alert,
  Button,
  FlatList,
  NativeModules,
  PermissionsAndroid,
  Pressable,
  Text,
} from 'react-native';
import Feather from 'react-native-vector-icons/Feather';
import styled from 'styled-components/native';
import {Container, Panel} from '../components';
import {CoreDate, ifRender} from '../core';
import {handleSmsPermissionAndroid} from '../helpers/HelperPermission';
import {Colors, Spacing} from '../styles';
import {perfectSize} from '../styles/spacing';
const {SharedPrefenceModule} = NativeModules;

export default inject('user')(
  observer(({navigation, user}) => {
    const {navigate} = navigation;
    const [history, setHistory] = useState([]);
    const [loaded, setLoaded] = useState(false);

    useLayoutEffect(() => {
      navigation.setOptions({
        headerRight: () => (
          <Pressable onPress={navigateToSettings}>
            <Feather name="settings" size={perfectSize(25)} />
          </Pressable>
        ),
      });
    }, [navigation]);

    useEffect(() => {
      handleSmsPermissionAndroid(PermissionsAndroid.PERMISSIONS.RECEIVE_SMS);
      const interval = setInterval(() => {
        (async () => {
          const res =
            (await SharedPrefenceModule.get('neo_smsHistory')) || '[]';
          setHistory(JSON.parse(res));
          if (!loaded) {
            setLoaded(true);
          }
        })();
      }, 2000);
      return () => clearInterval(interval);
    }, []);

    const navigateToSettings = () => {
      navigate('Settings');
    };

    const clearHistory = () => {
      Alert.alert(
        'Onay',
        'SMS geçmişini temizlemek istediğinize emin misiniz?',
        [
          {
            text: 'Hayır',
            style: 'destructive',
          },
          {
            text: 'Evet',
            onPress: () => {
              SharedPrefenceModule.set('neo_smsHistory', '[]');
              setHistory([]);
            },
            style: 'default',
          },
        ],
      );
    };

    const renderItem = ({item, index}) => (
      <Inset vertical={Spacing.s / 2} horizontal={2} key={index}>
        <Panel>
          <Inset bottom={Spacing.s}>
            <Text>{item.body}</Text>
          </Inset>
          <Row>
            <Flex>
              <TextMuted>{item.fromPhone}</TextMuted>
            </Flex>
            <TextMuted>
              {CoreDate.formatDate(item.date, 'DD.MM.YYYY HH:mm:ss')}
            </TextMuted>
          </Row>
        </Panel>
      </Inset>
    );

    return (
      <Container>
        {ifRender(
          !loaded,
          <Center>
            <Text>Mesajlar yükleniyor...</Text>
          </Center>,
        )}
        {ifRender(
          loaded && history.length === 0,
          <Center>
            <Text>Henüz yakalanmış SMS bulunamadı.</Text>
          </Center>,
        )}
        {ifRender(
          loaded && history.length > 0,
          <>
            <Header>
              <HeaderTitle>Son 100 mesaj</HeaderTitle>
              <Button onPress={clearHistory} title="Temizle" />
            </Header>
            <Stack size={Spacing.m} />
            <FlatList
              showsVerticalScrollIndicator={false}
              contentInset={{right: 20, top: 0, left: 0, bottom: 0}}
              data={history}
              renderItem={renderItem}
            />
          </>,
        )}
      </Container>
    );
  }),
);

const TextMuted = styled(Text)`
  color: ${Colors.GRAY_GRAY_1};
  font-size: ${perfectSize(12)}px;
`;

const Header = styled.View`
  align-items: center;
  justify-content: space-between;
  flex-direction: row;
`;

const HeaderTitle = styled(Text)`
  color: ${Colors.GRAY_GRAY_DARK_1};
  font-size: ${perfectSize(15)}px;
  font-weight: 500;
`;
