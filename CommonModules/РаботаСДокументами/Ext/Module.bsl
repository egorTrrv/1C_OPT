﻿#Область ПрограммныйИнтерфейс

Процедура УстановитьСтатусДокумента(Ссылка, НовыйСтатус) Экспорт
	
	ДокОбъект = Ссылка.ПолучитьОбъект();
	Попытка
		НачатьТранзакцию();
		
		Статусы = Перечисления.СтатусыЗаказов;
		
		Если НовыйСтатус = Статусы.Ожидается Тогда
			
			РаботаСПартиями.СоздатьПартииДокумента(ДокОбъект);
			План = Перечисления.ВидыДвиженияПланФакт.План;
			ЗаписатьДвиженияТоваров(Ссылка, План);
			ЗаписатьДвижениеДС(ДокОбъект, План);
			
		ИначеЕсли НовыйСтатус = Статусы.Завершен Тогда
			
			Факт = Перечисления.ВидыДвиженияПланФакт.Факт;
			ЗаписатьДвиженияТоваров(Ссылка, Факт);
			ЗаписатьДвижениеДС(ДокОбъект, Факт);
			
		ИначеЕсли НовыйСтатус = Статусы.Отменен Тогда
			
			УстановитьПривилегированныйРежим(Истина);	
			УдалитьДвиженияТоваров(Ссылка);
			УдалитьДвиженияДС(Ссылка);
			УстановитьПривилегированныйРежим(Ложь);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
		ДокОбъект.Статус = НовыйСтатус;
		ДокОбъект.ИндексКартинки = ИндексКартинкиСтатуса(НовыйСтатус);
		ДокОбъект.Записать();
	Исключение
		ОтменитьТранзакцию();
		Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

Процедура СторнироватьСтрокуЗаказа(СторноСсылка, ОснованиеСсылка, Номенклатура) Экспорт

	// Набор аргументов однозначно определяет сторнируемую строку
	Попытка
		НачатьТранзакцию();
		
		ОснованиеОбъект = ОснованиеСсылка.ПолучитьОбъект();
		Отбор = Новый Структура();
		Отбор.Вставить("Номенклатура", Номенклатура);
		Результат = ОснованиеОбъект.СтрокиЗаказа.НайтиСтроки(Отбор);
		Если Результат = Неопределено ИЛИ Результат.Количество() > 1 Тогда
			ВызватьИсключение "Не найдена сторнируемая строка!";
		КонецЕсли;
		
		СторноСсылка.ПолучитьОбъект().Записать(РежимЗаписиДокумента.Проведение);//
		
		СторнируемаяСтрока = Результат[0];
		ДанныеСторно = ДанныеСторно(СторноСсылка);
		
		СторнируемаяСтрока.Упаковка				= ДанныеСторно.Упаковка;
		СторнируемаяСтрока.КоличествоУпаковок	= ДанныеСторно.КоличествоУпаковок;
		СторнируемаяСтрока.ЕдиницаИзмерения		= ДанныеСторно.ЕдиницаИзмерения;
		СторнируемаяСтрока.Количество			= ДанныеСторно.Количество;
		СторнируемаяСтрока.СтоимостьЗаЕдиницу	= ДанныеСторно.СтоимостьЗаЕдиницу;
		СторнируемаяСтрока.Сумма				= ДанныеСторно.Сумма;
		
		ОснованиеОбъект.Записать();
		ЗафиксироватьТранзакцию();
		ОснованиеСсылка.ПолучитьОбъект().Прочитать();

	Исключение
		ОтменитьТранзакцию();
		Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьДвиженияТоваров(Ссылка, ВидДвижения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаЗакупкуСтрокиЗаказа.Номенклатура КАК Номенклатура,
		|	ЗаказНаЗакупкуСтрокиЗаказа.Упаковка КАК Упаковка,
		|	ЗаказНаЗакупкуСтрокиЗаказа.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ЗаказНаЗакупкуСтрокиЗаказа.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗаказНаЗакупкуСтрокиЗаказа.Количество КАК Количество,
		|	ЗаказНаЗакупкуСтрокиЗаказа.СтоимостьЗаЕдиницу КАК СтоимостьЗаЕдиницу,
		|	ЗаказНаЗакупкуСтрокиЗаказа.Сумма КАК Сумма,
		|	ЗаказНаЗакупкуСтрокиЗаказа.Партия КАК Партия
		|ИЗ
		|	Документ.ЗаказНаЗакупку.СтрокиЗаказа КАК ЗаказНаЗакупкуСтрокиЗаказа
		|ГДЕ
		|	ЗаказНаЗакупкуСтрокиЗаказа.Ссылка = &Ссылка
		|	И НЕ ЗаказНаЗакупкуСтрокиЗаказа.Номенклатура В
		|				(ВЫБРАТЬ
		|					ДвижениеТовара.Номенклатура КАК Номенклатура
		|				ИЗ
		|					Документ.ДвижениеТовара КАК ДвижениеТовара
		|				ГДЕ
		|					ДвижениеТовара.ДокументОснование = &Ссылка
		|					И ДвижениеТовара.ВидДвиженияПланФакт = &ВидДвижения)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвижения);

	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтрокиЗаказа = РезультатЗапроса.Выгрузить();
	
	Для Каждого СтрокаТЧ Из СтрокиЗаказа Цикл
		
		ДокДвижениеТоваров = Документы.ДвижениеТовара.СоздатьДокумент();
		ДокДвижениеТоваров.ДокументОснование = Ссылка;
		ДокДвижениеТоваров.ВидДвиженияПланФакт = ВидДвижения;
		ДокДвижениеТоваров.Дата = ТекущаяДатаСеанса();
		ДокДвижениеТоваров.Номенклатура = СтрокаТЧ.Номенклатура;
		ДокДвижениеТоваров.Партия = СтрокаТЧ.Партия;
		ДокДвижениеТоваров.Упаковка = СтрокаТЧ.Упаковка;
		ДокДвижениеТоваров.КоличествоУпаковок = СтрокаТЧ.КоличествоУпаковок;
		ДокДвижениеТоваров.ЕдиницаИзмерения = СтрокаТЧ.ЕдиницаИзмерения;
		ДокДвижениеТоваров.Количество = СтрокаТЧ.Количество;
		ДокДвижениеТоваров.МестоОтправления = Ссылка.Контрагент;
		ДокДвижениеТоваров.МестоПолучения = Ссылка.СкладПоступления;
		ДокДвижениеТоваров.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;

КонецПроцедуры

//ТарураевЕ { 1.0.4 # 13.03.2023
Процедура ЗаписатьДвижениеДС(ДокОбъект, ВидДвижения)
	Запрос = Новый Запрос;
	Ссылка = ДокОбъект.Ссылка;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаЗакупкуСтрокиЗаказа.Сумма КАК Сумма
		|ИЗ
		|	Документ.ЗаказНаЗакупку.СтрокиЗаказа КАК ЗаказНаЗакупкуСтрокиЗаказа
		|ГДЕ
		|	ЗаказНаЗакупкуСтрокиЗаказа.Ссылка = &Ссылка
		|	И НЕ ЗаказНаЗакупкуСтрокиЗаказа.Сумма В
		|				(ВЫБРАТЬ
		|					ДвижениеДенежныхСредств.Сумма КАК Сумма
		|				ИЗ
		|					Документ.ДвижениеДенежныхСредств КАК ДвижениеДенежныхСредств
		|				ГДЕ
		|					ДвижениеДенежныхСредств.ДокументОснование = &Ссылка
		|					И ДвижениеДенежныхСредств.ВидДвиженияПланФакт = &ВидДвижения)";
	//
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвижения);

	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтрокиЗаказа = РезультатЗапроса.Выгрузить();
	
	Для Каждого СтрокаТЧ Из СтрокиЗаказа Цикл
		
		ДокДвижениеДС = Документы.ДвижениеДенежныхСредств.СоздатьДокумент();
		ДокДвижениеДС.ДокументОснование = ссылка;
		ДокДвижениеДС.ВидДвиженияПланФакт = ВидДвижения;
		ДокДвижениеДС.Дата = ТекущаяДатаСеанса();
		ДокДвижениеДС.Договор = ссылка.ДоговорОснование;
		ДокДвижениеДС.Сумма = СтрокаТЧ.Сумма;
		ДокДвижениеДС.Ответственный = Ссылка.Ответственный;
		ДокДвижениеДС.Записать(РежимЗаписиДокумента.Проведение);		
	КонецЦикла; 
КонецПроцедуры

Процедура УдалитьДвиженияДС(ДокументОснование)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеДенежныхСредств.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДвижениеДенежныхСредств КАК ДвижениеДенежныхСредств
		|ГДЕ
		|	ДвижениеДенежныхСредств.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ДокОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ДокОбъект.ПометкаУдаления = Истина;
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
	КонецЦикла;
	

КонецПроцедуры
//}ТарураевЕ 1.0.4 # 13.03.2023
                
Процедура УдалитьДвиженияТоваров(ДокументОснование)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеТовара.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДвижениеТовара КАК ДвижениеТовара
		|ГДЕ
		|	ДвижениеТовара.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ДокОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ДокОбъект.ПометкаУдаления = Истина;
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИндексКартинкиСтатуса(Статус)
	
	Если Статус = Перечисления.СтатусыЗаказов.Ожидается Тогда
		
		Возврат 1;
		
	ИначеЕсли Статус = Перечисления.СтатусыЗаказов.Завершен Тогда
		
		Возврат 5;
		
	ИначеЕсли Статус = Перечисления.СтатусыЗаказов.Отменен Тогда
		
		Возврат 6;
		
	КонецЕсли;

КонецФункции // ИндексКартинкиСтатуса()

Функция ДанныеСторно(СторноСсылка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СторнированиеСтрокиЗаказа.Упаковка КАК Упаковка,
		|	СторнированиеСтрокиЗаказа.КоличествоУпаковок КАК КоличествоУпаковок,
		|	СторнированиеСтрокиЗаказа.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СторнированиеСтрокиЗаказа.Количество КАК Количество,
		|	СторнированиеСтрокиЗаказа.СтоимостьЗаЕдиницу КАК СтоимостьЗаЕдиницу,
		|	СторнированиеСтрокиЗаказа.Сумма КАК Сумма
		|ИЗ
		|	Документ.СторнированиеСтрокиЗаказа КАК СторнированиеСтрокиЗаказа
		|ГДЕ
		|	СторнированиеСтрокиЗаказа.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СторноСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить()[0];

КонецФункции // ТаблицаИзмененийСторно()

#КонецОбласти



