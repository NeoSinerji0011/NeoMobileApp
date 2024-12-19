import CoreDate from './date';

const ifRender = (
  condition: boolean | string | number | null | undefined,
  element: JSX.Element,
  elseElement?: JSX.Element,
) => (condition ? element : elseElement);

const runInTry = async (callback: () => Promise<void>) => {
  try {
    // StoreGeneral.showAppLoading()
    await callback?.call(null);
  } catch (e) {
    // StoreGeneral.showDialogModal(e, 'Hata')
  } finally {
    // StoreGeneral.hideAppLoading()
  }
};

export {CoreDate, ifRender, runInTry};
