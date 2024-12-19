import dayjs, {OpUnitType} from 'dayjs'
import 'dayjs/locale/tr'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import isToday from 'dayjs/plugin/isToday'
import isTomorrow from 'dayjs/plugin/isTomorrow'
import relativeTime from 'dayjs/plugin/relativeTime'

dayjs.locale('tr')
dayjs.extend(relativeTime)
dayjs.extend(isToday)
dayjs.extend(isTomorrow)
dayjs.extend(customParseFormat)

export default {
  getDate(date: dayjs.ConfigType) {
    return dayjs(date).toDate()
  },
  formatDate(date: dayjs.ConfigType, formatType: string = 'DD.MM.YYYY') {
    return dayjs(date).format(formatType)
  },
  diff(
    firstDate: dayjs.ConfigType,
    secondDate: dayjs.ConfigType,
    unit: OpUnitType
  ) {
    return dayjs(firstDate).diff(secondDate, unit)
  },
  get now() {
    return dayjs().toDate()
  },
  relative(date: dayjs.ConfigType) {
    return dayjs().to(date)
  },
  getDayNames(date: dayjs.ConfigType) {
    if (dayjs(date).isToday()) {
      return 'BUGÜN'
    }
    return dayjs(date).locale('tr').format('dddd')
  },
  getDayOfMonth(date: dayjs.ConfigType) {
    return dayjs(date).format('D')
  },
  getTime(date: dayjs.ConfigType, format: string = 'HH:mm:ss') {
    return dayjs(date).format(format)
  },
  getMonthOfYear(date: dayjs.ConfigType) {
    return dayjs(date).format('MM')
  },
  getMonthNameOfYear(date: dayjs.ConfigType) {
    return dayjs(date).format('MMMM')
  },
  getYearOfDate(date: dayjs.ConfigType) {
    return dayjs(date).format('YYYY')
  },
  getByUnix(date: dayjs.ConfigType) {
    return dayjs(date).unix()
  },
  addDayToDate(
    date: dayjs.ConfigType,
    value: number,
    format: string = 'DD.MM.YYYY'
  ) {
    return dayjs(date).add(value, 'day').format(format)
  },
  addMonth(date: dayjs.ConfigType, value: number) {
    return dayjs(
      date || __DEV__ ? dayjs(new Date(2021, 1, 1, 0, 0, 0, 0)) : undefined
    )
      .add(value, 'month')
      .endOf('month')
  },
  addDayToToday(value: number, format: string = 'DD.MM.YYYY') {
    return dayjs(__DEV__ ? dayjs(new Date(2021, 1, 1, 0, 0, 0, 0)) : undefined)
      .add(value, 'day')
      .format(format)
  },
  addYearToToday(value: number) {
    return dayjs().add(value, 'year').format('DD.MM.YYYY')
  },
  get currentYear() {
    return dayjs().format('YYYY')
  },
  get subtractCurrentYearByOne() {
    return dayjs().subtract(1, 'year').format('YYYY')
  },
  get currentHour() {
    return dayjs().hour()
  },
  asTime(seconds: number) {
    const minutes = Math.floor(seconds / 60).toFixed(0)
    const _seconds = (seconds % 60).toFixed(0)
    return `${minutes.padStart(2, '0')}:${_seconds.padStart(2, '0')}`
  },
  getDayjsFormattedDate(date: dayjs.ConfigType) {
    return dayjs(date, 'YYYY-MM-DD').toString()
  },
  addHoursToDate(
    date: dayjs.ConfigType,
    hours: number,
    format: string = 'DD.MM.YYYY'
  ) {
    return dayjs(date).add(hours, 'hours').format(format)
  },
  isValid(date: dayjs.ConfigType, format: string = 'DD.MM.YYYY') {
    return dayjs(date, format, true).isValid()
  },
  isToday(date: dayjs.ConfigType) {
    return dayjs(date).isToday()
  },
  isTomorrow(date: dayjs.ConfigType) {
    return dayjs(date).isTomorrow()
  }
}
