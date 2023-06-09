﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтрокиЗаказа.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
		
		НовыйОтбор = СтрокиЗаказа.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = ТекущиеДанные.Ссылка;
		
		Если ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Ожидается") Тогда
			Элементы.СторнироватьСтроку.Доступность = Истина;
			Элементы.УдалитьСтроку.Доступность = Истина;
		Иначе
		    Элементы.СторнироватьСтроку.Доступность = Ложь;
			Элементы.УдалитьСтроку.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		ОткрытьФорму("Документ.ЗаказНаЗакупку.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СторнироватьСтроку(Команда)
	
    ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Новый Структура("Номенклатура, Партия, Упаковка, КоличествоУпаковок, ЕдиницаИзмерения, Количество, СтоимостьЗаЕдиницу, Сумма, Заказ",
									ТекущиеДанные.Номенклатура,
									ТекущиеДанные.Партия,
									ТекущиеДанные.Упаковка,
									ТекущиеДанные.КоличествоУпаковок,
									ТекущиеДанные.ЕдиницаИзмерения,
									ТекущиеДанные.Количество,
									ТекущиеДанные.СтоимостьЗаЕдиницу,
									ТекущиеДанные.Сумма,
									ТекущиеДанные.Ссылка);
									
	ПараметрыФормы = Новый Структура("ДанныеСтроки", ДанныеСтроки);
	ОткрытьФорму("Документ.СторнированиеСтрокиЗаказа.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
