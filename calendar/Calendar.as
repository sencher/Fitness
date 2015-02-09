package {

import Events.CalendarEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Calendar extends MovieClip {

		public static const XGRID:Number = 12;//координаты сетки из ячеек с датами и панельки с днями недели
		public static const YGRID:Number = 95;
		public static const YDAYS:Number = 60;
		public static const BETWEENCELLS:Number = 5;//расстояние между ячейками

		private var today:Date;
		private var _dateObject:Date;//экземпляр нужен для получения значений текущей даты, дня недели, года

		public var currentDate:Number;//текущая дата
		public var currentDay:Number;//текущий день недели
		public var currentMonth:Number;//текущий месяц
		public var currentYear:Number;//текущий год
		private var _days:Array;//массив для хранения названий дней недели
		private var _dates:Array;//массив для хранения дат
		private var _months:Array;//массив для хранения названий месяцев
		private var _daysinMonth:Array;//массив для хранения количества дней в месяце

		private var _nextMonthButton:NextMonthButton;//кнопки
		private var _prevMonthButton:PrevMonthButton;
		private var _nextYearButton:NextYearButton;
		private var _prevYearButton:PrevYearButton;
		private var _textCurrentMonth:TextField;//текстовое поле для названия месяца
		private var _textCurrentYear:TextField;//текстовое поле для значения года
		private var _formateTextMonthAndYear:TextFormat;//форматы для текстовых полей
		private var _formateTextDate:TextFormat;
		private var _formateTextDays:TextFormat;

		private var _startCell:Number;
//        private var _visits:Vector.<Date>;
    private var _orange:Date;
    private var _purple:Vector.<Date>;
    private const ORANGE:String = 'orange';
    private const PURPLE:String = 'purple';
        //ячейка с сегодняшней датой

		public function Calendar() {
			init();
		}

		private function init():void {

            today = new Date();
			_dateObject = new Date();
			currentDate = _dateObject.getDate();
			currentDay = _dateObject.getDay();
			currentYear = _dateObject.getFullYear();
			currentMonth =	_dateObject.getMonth();
			_days = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс']
			_months = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"];
			_daysinMonth = [31,28,31,30,31,30,31,31,30,31,30,31];

			buildHeader();//создаем текстовые поля для названия месяца, года; создаем панельку с днями недели
			buildGrid();//создаем сетку из ячеек с датами
			showColorDates();//изменяем сетку в соответствии с видом текущего месяца
			
			//когда пользователь кликает по кнопкам	для изменения даты или года (см метод onClick()),
			//мы отправляем событие Calendar.CHANGEDATE, которое обрабатывает метод onChangeDate()
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(CalendarEvent.REDRAW, onChangeDate);
			addEventListener(MouseEvent.ROLL_OVER, onROver, true);//а это, чтоб покрасивее :)
			addEventListener(MouseEvent.ROLL_OUT, onROut, true);
		}

		private function buildHeader():void {
			
			//создаем экземпляр текстового поля с присоединенным шрифтом, чтобы
			//этот шрифт можно было использовать в нашем ролике
			var textEmbed:TextEmbed = new TextEmbed();
			
			//создаем формат текстовых полей для названия месяца и значения года
			_formateTextMonthAndYear = new TextFormat();
			_formateTextMonthAndYear.color = 0x333333;
			_formateTextMonthAndYear.font = 'Tahoma';
			_formateTextMonthAndYear.size = '16';
			_formateTextMonthAndYear.bold = true;
			_formateTextMonthAndYear.align = TextFormatAlign.CENTER;
			
			//создаем формат текстового поля для значений даты
			_formateTextDate = new TextFormat();
			_formateTextDate.color = 0xffffff;
			_formateTextDate.font = 'Tahoma';
			_formateTextDate.size = '13';
			_formateTextDate.bold = true;
			_formateTextDate.align = TextFormatAlign.CENTER;
			
			//создаем формат текстового поля для значений дней недели
			_formateTextDays = new TextFormat();
			_formateTextDays.color = 0xffffff;
			_formateTextDays.font = 'Tahoma';
			_formateTextDays.size = '14';
			_formateTextDays.bold = true;
			_formateTextDays.align = TextFormatAlign.CENTER;

			//создаем текстовое поле для названия месяца
			_textCurrentMonth = new TextField();
			_textCurrentMonth.selectable = false;
			_textCurrentMonth.defaultTextFormat = _formateTextMonthAndYear;
			_textCurrentMonth.embedFonts = true;
			_textCurrentMonth.x = 23;
			_textCurrentMonth.y = 25;
			_textCurrentMonth.width = 90;
			_textCurrentMonth.height = 40;
			_textCurrentMonth.text = _months[currentMonth];
			addChild(_textCurrentMonth);

			//создаем текстовое поле для значения года
			_textCurrentYear = new TextField();
			_textCurrentYear.embedFonts = true;
			_textCurrentYear.selectable = false;
			_textCurrentYear.defaultTextFormat = _formateTextMonthAndYear;
			_textCurrentYear.x = 137;
			_textCurrentYear.y = 25;
			_textCurrentYear.width = 80;
			_textCurrentYear.height = 40;
			_textCurrentYear.text = currentYear.toString();
			addChild(_textCurrentYear);

			//создаем ячейки с названиями дней недели
			for (var i:int = 0; i < _days.length; i++) {
				var bgDay:BgDay = new BgDay();
				addChild(bgDay);
				bgDay.x = i * (bgDay.width + BETWEENCELLS) + XGRID;
				bgDay.y = YDAYS;
				
				var textDay:TextField = new TextField();
				textDay.mouseEnabled = false;
				textDay.selectable = false;
				textDay.text = _days[i];
				textDay.width = 30;
				textDay.height = 30;
				textDay.embedFonts = true;
				textDay.setTextFormat(_formateTextDays);
				bgDay.addChild(textDay);
				textDay.x = -3;//эти значения получаем опытным путем :)
				textDay.y = 1;
				
			}
			
			
			//создаем кнопки для изменения месяцев и лет
			_nextMonthButton = new NextMonthButton();
			_nextMonthButton.stop();
			_nextMonthButton.x = 115;
			_nextMonthButton.y = 33;
			_nextMonthButton.buttonMode = true;
			_nextMonthButton.useHandCursor = true;
			addChild(_nextMonthButton);

			_prevMonthButton = new PrevMonthButton();
			_prevMonthButton.stop();
			_prevMonthButton.x = 15;
			_prevMonthButton.y = 33;
			_prevMonthButton.buttonMode = true;
			_prevMonthButton.useHandCursor = true;
			addChild(_prevMonthButton);

			_nextYearButton = new NextYearButton();
			_nextYearButton.stop();
			_nextYearButton.x = 209;
			_nextYearButton.y = 33;
			_nextYearButton.buttonMode = true;
			_nextYearButton.useHandCursor = true;
			addChild(_nextYearButton);

			_prevYearButton = new PrevYearButton();
			_prevYearButton.stop();
			_prevYearButton.x = 137;
			_prevYearButton.y = 33;
			_prevYearButton.buttonMode = true;
			_prevYearButton.useHandCursor = true;
			addChild(_prevYearButton);
		}

        public function updateColors(purple:Vector.<Date>, orange:Date = null):void{
            _orange = orange || new Date();
            _purple = purple;

            currentDate = _orange.date;
            currentMonth = _orange.month;
            currentYear = _orange.fullYear;

            updateHeaderLabels();
            onChangeDate();
        }

		private function onChangeDate(e:Event = null):void {
			clearGrid();//убираем старую сетку
			buildGrid();//делаем новую
			showColorDates();
		}

		private function clearGrid():void {
			
			//удаляем все ячейки
			_dates = null;
			while (getChildAt(numChildren-1) is BgDate) {
				removeChild(getChildAt(numChildren-1));
			};
			
			//создаем новый объект Date, со значениями года и месяца, которые выбрал пользователь
			_dateObject = new Date(currentYear,currentMonth, currentDate);
			currentDate = _dateObject.getDate();
			currentDay = _dateObject.getDay();
			currentYear = _dateObject.getFullYear();
			currentMonth =	_dateObject.getMonth();
		}

		private function showColorDates():void {

			//небольшая проверка на високосный год, если год не високосный, то в феврале 28 дней
			_daysinMonth[1] = 28;

			//если високосный - 29
			if ((currentYear / 4 - Math.floor(currentYear / 4) == 0)) {
				_daysinMonth[1] = 29;
			}

			if (currentYear / 100 - Math.floor(currentYear / 100) == 0 &&
			currentYear / 400 - Math.floor(currentYear / 400) != 0) {
				_daysinMonth[1] = 28;
			}

			//ищем в сетке ближайшую ячейку, день недели которой совпадает со значением _currentDay
			for (var i:Number = currentDate - 1; i < _dates.length - 1; i++) {
				if (_dates[i][1] == currentDay) {
					_startCell = i;
//                    if(checkVisit())
//                    if(currentMonth == today.month && currentYear == today.fullYear && currentDate == today.date)
//					    _dates[i][2].gotoAndStop(ORANGE);
					break;
				}
			}

			var tempNumber:Number;
			tempNumber = _startCell;

			//функция добавляет текстовое поле в ячейку
			function attachTextField(it:Number):void {
				var textDate:TextField = new TextField();
                var bg:MovieClip = _dates[tempNumber][2];
				textDate.mouseEnabled = false;
				textDate.selectable = false;
				textDate.text = it.toString();
				textDate.width = 30;
				textDate.height = 30;
				textDate.embedFonts = true;
				textDate.setTextFormat(_formateTextDate);
                var color:String = checkColor(it);
                if(color) bg.gotoAndStop(color);
                bg.addChild(textDate);
                bg.id = it;
				textDate.x = -3;//эти значения получаем опытным путем :)
				textDate.y = 1;
			}

			//добавляем текстовые поля к ячейкам от текущей даты до первого числа месяца
			for (var j:Number = currentDate; j > 0; j--) {
				attachTextField(j);
				tempNumber--;
			}

			//восстанавливаем значение tempNumber
			tempNumber = _startCell;

			//добавляем текстовые поля к ячейкам от текущей даты до последнего числа месяца
			for (var k:Number = currentDate; k <= _daysinMonth[currentMonth]; k++) {
				attachTextField(k);
				tempNumber++;
			}

			//удаляем ячейки без текстовых полей из списка отображения, хотя можно этого и не делать,
			//а просто изменять их внешний вид
			for (var l:Number = 0; l < _dates.length ; l++) {
				if (_dates[l][2].numChildren==1) {
					removeChild(_dates[l][2]);
				}
			}
		}

        private function checkColor(checkDate:int):String {
            var date:Date;
            if(_orange && areDatesEqual(_orange, checkDate)) return ORANGE;

            for each (date in _purple){
//                trace(_currentMonth,date.month,checkDate,date.date,_currentYear,date.fullYear);
                if(areDatesEqual(date, checkDate)) return PURPLE;
            }
            return null;
        }

        private function areDatesEqual(date:Date, checkDate:int):Boolean {
            return currentMonth == date.month && checkDate == date.date && currentYear == date.fullYear;
        }

		//создаем сетку из ячеек дат
		private function buildGrid():void {

			_dates = new Array();

			var it:Number = 0;

			for (var i:Number = 0; i < 6; i++) {

				for (var j:Number = 0; j <= 7; j++) {

					if (j == 7) {
						break;
					}
					it++;
					var dateOfMonth:Number;
					dateOfMonth = it;

					var dayOfWeek:Number;
					dayOfWeek = j + 1;
					if (dayOfWeek == 7) {
						dayOfWeek = 0;
					}

					var bgDate:BgDate = new BgDate();
					addChild(bgDate);
					bgDate.x = j * (bgDate.width + BETWEENCELLS) + XGRID;
					bgDate.y = i * (bgDate.height + BETWEENCELLS) + YGRID;

					_dates.push([dateOfMonth, dayOfWeek, bgDate]);
				}
			}
		}
		
		//обработчик события MouseEvenе.ROLL_OVER - при наведении мыши окрашиваем ячейку  в другой цвет
		//и немного поднимаем относительно других
		private function onROver(e:MouseEvent):void {

			if (e.target is BgDate) {
				if (e.target.currentFrameLabel == ORANGE) {//если это ячейка с сегодняшним днем ничего не делаем
				} else {
                    e.target.previousFrameLabel = e.target.currentFrameLabel;
					e.target.gotoAndStop('rollover');
				}
			}
            e.target.y = e.target.y - 2;
		}

		//обработчик события MouseEvenе.ROLL_OUT - окрашиваем ячейку в начальный цвет
		//и возвращаем начальное значение координате y
		private function onROut(e:MouseEvent):void {

			if (e.target is BgDate) {
				if (e.target.currentFrameLabel == ORANGE) {
				} else {
					e.target.gotoAndStop(e.target.previousFrameLabel);
				}
			}
            e.target.y = e.target.y + 2;
		}

    private function updateHeaderLabels():void{
        _textCurrentYear.text = currentYear.toString();
        _textCurrentMonth.text = _months[currentMonth];
    }
		
		//обработчик события MouseEvent.CLICK - здесь меняем месяцы и даты
		//и отправляем событие Calendar.CHANGEDATE
		private function onClick(e:MouseEvent):void {
            var selectedDate:Date;
			if (e.target is NextMonthButton || e.target is PrevMonthButton
			||e.target is NextYearButton || e.target is PrevYearButton) {

				if (e.target is NextMonthButton) {
					currentMonth++;
					if (currentMonth == 12) {
						currentMonth = 0;
						currentYear++;
					}
				} else if (e.target is PrevMonthButton) {
					currentMonth--;
					if (currentMonth == -1) {
						currentMonth = 11;
						currentYear--;
					}
				} else if (e.target is NextYearButton) {
					currentYear++;
				} else if (e.target is PrevYearButton) {
					currentYear--;
				}
                updateHeaderLabels();

                selectedDate = new Date(currentYear, currentMonth);
				dispatchEvent(new CalendarEvent(CalendarEvent.REDRAW, selectedDate, true));
			}else if(e.target is BgDate){
                selectedDate = new Date(currentYear, currentMonth, e.target.id);
                dispatchEvent(new CalendarEvent(CalendarEvent.SELECTED, selectedDate, true));
            }
		}
	}
}