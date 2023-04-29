﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Статус) Тогда
    	ВыполнитьНачальноеЗаполнение();
	КонецЕсли;
	ОбновитьДоступностьЭлементовФормы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСтрокиЗаказа

&НаКлиенте
Процедура СтрокиЗаказаПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьЭлементовТаблицыСтрокиЗаказа();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокиЗаказаНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Номенклатура = ТекущиеДанные.Номенклатура;
		
		ТекущиеДанные.ЕдиницаИзмерения = ОбщегоНазначенияСервер.ЗначениеРеквизита(Номенклатура, "БазоваяЕдиницаИзмерения");
		ТекущиеДанные.Упаковка = РаботаСНоменклатурой.УпаковкиНоменклатуры(Номенклатура)[0];
		УстановитьДоступностьЭлементовТаблицыСтрокиЗаказа();	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокиЗаказаКоличествоУпаковокПриИзменении(Элемент)
	
	ВыполнитьПересчет();
	//ТарураевЕ { 1.0.4 # 13.03.2023
	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.СтоимостьЗаЕдиницу * ТекущиеДанные.КоличествоУпаковок;
КонецПроцедуры
&НаКлиенте
Процедура СтрокиЗаказаУпаковкаПриИзменении(Элемент)
	ВыполнитьПересчет();
	УстановитьДоступностьЭлементовТаблицыСтрокиЗаказа();//в случае изменения упаковки на "без упаковки"	
КонецПроцедуры  


&НаКлиенте
Процедура СтрокиЗаказаКоличествоПриИзменении(Элемент)
	
	ВыполнитьПересчет();	
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокиЗаказаСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	ТекущиеДанные.СтоимостьЗаЕдиницу = ТекущиеДанные.Сумма / ТекущиеДанные.КоличествоУпаковок;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокиЗаказаСтоимостьЗаЕдиницуПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.СтоимостьЗаЕдиницу * ТекущиеДанные.КоличествоУпаковок;
	
КонецПроцедуры
//}ТарураевЕ 1.0.4 # 13.03.2023

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусОжидается(Команда)
	
	НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Ожидается");
	РаботаСДокументами.УстановитьСтатусДокумента(Объект.Ссылка, НовыйСтатус);	
	ЭтотОбъект.Прочитать();
	ОбновитьОтображениеДанных();
	ОбновитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗавершен(Команда)
	
    НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Завершен");
	РаботаСДокументами.УстановитьСтатусДокумента(Объект.Ссылка, НовыйСтатус);	
	ЭтотОбъект.Прочитать(); //ТарураевЕ 1.0.4 # 13.03.2023
	ОбновитьОтображениеДанных();
	ОбновитьДоступностьЭлементовФормы(); //ТарураевЕ 1.0.4 # 13.03.2023
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Отменен");
	РаботаСДокументами.УстановитьСтатусДокумента(Объект.Ссылка, НовыйСтатус);	
	ЭтотОбъект.Прочитать();//ТарураевЕ 1.0.4 # 13.03.2023
	ОбновитьОтображениеДанных();
	ОбновитьДоступностьЭлементовФормы();//ТарураевЕ 1.0.4 # 13.03.2023

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
									Объект.Ссылка);
									
	ПараметрыФормы = Новый Структура("ДанныеСтроки", ДанныеСтроки);
	ОткрытьФорму("Документ.СторнированиеСтрокиЗаказа.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ВыполнитьНачальноеЗаполнение()

	Объект.Статус = Перечисления.СтатусыЗаказов.Новый;
	Объект.ИндексКартинки = 0;
	
КонецПроцедуры // ВыполнитьНачальноеЗаполнение()

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы()
	
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Новый") Тогда 
		
		Элементы.УстановитьСтатусОжидается.Видимость = Истина;
		Элементы.ФормаУстановитьСтатусЗавершен.Видимость = Ложь;
		Элементы.ФормаУстановитьСтатусОтменен.Видимость = Ложь;
		Элементы.СтрокиЗаказаСторнироватьСтроку.Видимость = Ложь;
		Элементы.СтрокиЗаказаУдалитьСтроку.Видимость = Ложь;
		
	ИначеЕсли Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Ожидается") Тогда
		// Недоступен для редактирования
		УправлениеДоступностьюРедактированияРеквизитов.ЗаблокироватьРеквизиты(ЭтаФорма, Объект.Ссылка);
		
		Элементы.УстановитьСтатусОжидается.Видимость = Ложь;
		Элементы.ФормаУстановитьСтатусЗавершен.Видимость = Истина;
		Элементы.ФормаУстановитьСтатусОтменен.Видимость = Истина;
		Элементы.СтрокиЗаказаСторнироватьСтроку.Видимость = Истина;
		Элементы.СтрокиЗаказаУдалитьСтроку.Видимость = Истина;
		
		Элементы.СтрокиЗаказа.ТолькоПросмотр = Истина;
		
	ИначеЕсли Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Завершен") Тогда
		
		Элементы.УстановитьСтатусОжидается.Видимость = Ложь;
		Элементы.ФормаУстановитьСтатусЗавершен.Видимость = Ложь;
		Элементы.ФормаУстановитьСтатусОтменен.Видимость = Ложь;
		Элементы.СтрокиЗаказаСторнироватьСтроку.Видимость = Ложь;
		Элементы.СтрокиЗаказаУдалитьСтроку.Видимость = Ложь;
		
		Элементы.СтрокиЗаказа.ТолькоПросмотр = Истина;
		
	ИначеЕсли Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказов.Отменен") Тогда
		
		Элементы.ФормаУстановитьСтатусЗавершен.Видимость = Ложь;
		Элементы.ФормаУстановитьСтатусОтменен.Видимость = Ложь;
		Элементы.УстановитьСтатусОжидается.Видимость = Ложь;
		Элементы.СтрокиЗаказаСторнироватьСтроку.Видимость = Ложь;
		Элементы.СтрокиЗаказаУдалитьСтроку.Видимость = Ложь;
		
		Элементы.СтрокиЗаказа.ТолькоПросмотр = Истина;
		
	КонецЕсли;

КонецПроцедуры // ОбновитьДоступностьЭлементовФормы()

&НаКлиенте
Процедура ВыполнитьПересчет()

	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	
	Если ТекущиеДанные.Упаковка = ПредопределенноеЗначение("Справочник.УпаковкиНоменклатуры.БезУпаковки") Тогда
		
		ТекущиеДанные.КоличествоУпаковок = ТекущиеДанные.Количество;
		
	Иначе
		
		КратностьУпаковки = ОбщегоНазначенияСервер.ЗначениеРеквизита(ТекущиеДанные.Упаковка, "Кратность");
		ТекущиеДанные.Количество = ТекущиеДанные.КоличествоУпаковок * КратностьУпаковки;	
		
	КонецЕсли;

КонецПроцедуры // ВыполнитьПересчёт()

&НаКлиенте
Процедура УстановитьДоступностьЭлементовТаблицыСтрокиЗаказа()
	
	ТекущиеДанные = Элементы.СтрокиЗаказа.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Упаковка = ПредопределенноеЗначение("Справочник.УпаковкиНоменклатуры.БезУпаковки") Тогда
		Элементы.СтрокиЗаказаКоличествоУпаковок.Доступность = Ложь;
		Элементы.СтрокиЗаказаКоличество.Доступность = Истина;
	Иначе
		Элементы.СтрокиЗаказаКоличество.Доступность = Ложь;
		Элементы.СтрокиЗаказаКоличествоУпаковок.Доступность = Истина;
	КонецЕсли;	

КонецПроцедуры // УстановитьДоступностьЭлементовТаблицыСтрокиЗаказа()



#КонецОбласти

