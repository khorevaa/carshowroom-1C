﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КлючВарианта		= Параметры.КлючТекущихНастроек;
	ТекущийПользователь	= ПользователиКлиентСервер.АвторизованныйПользователь();

	ОтчетИнформация		= ВариантыОтчетовСервер.СформироватьИнформациюОбОтчетеПоПолномуИмени(Параметры.КлючОбъекта);
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	ОтчетИнформация.Удалить("ОтчетМетаданные");
	ОтчетИнформация.Удалить("ТекстОшибки");
	ОтчетИнформация.Вставить("ОтчетПолноеИмя", Параметры.КлючОбъекта);
	ОтчетИнформация = Новый ФиксированнаяСтруктура(ОтчетИнформация);

	ПолныеПраваНаВарианты = РольДоступна(Метаданные.Роли.ПолныеПрава);

	Если Не ПолныеПраваНаВарианты Тогда
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Видимость		= Ложь;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Видимость	= Ложь;
		ПоказыватьЛичныеВариантыОтчетовДругихАвторов						= Ложь;
	КонецЕсли;

	ЗаполнитьСписокВариантов();
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Показывать = Настройки.Получить("ПоказыватьЛичныеВариантыОтчетовДругихАвторов");
	Если Показывать <> ПоказыватьЛичныеВариантыОтчетовДругихАвторов Тогда
		ПоказыватьЛичныеВариантыОтчетовДругихАвторов					= Показывать;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Пометка	= Показывать;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Пометка	= Показывать;
		ЗаполнитьСписокВариантов();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	ОтборВключен = ЗначениеЗаполнено(ОтборАвтор);

	ГруппыИлиВарианты = ДеревоВариантовОтчета.ПолучитьЭлементы();
	Для Каждого ГруппаИлиВариант Из ГруппыИлиВарианты Цикл
		ЕстьВключенные		= Неопределено;
		ВложенныеВарианты	= ГруппаИлиВариант.ПолучитьЭлементы();
		Для Каждого Вариант Из ВложенныеВарианты Цикл
			Вариант.СкрытОтбором = ОтборВключен И Вариант.Автор <> ОтборАвтор;
			Если Не Вариант.СкрытОтбором Тогда
				ЕстьВключенные = Истина;
			ИначеЕсли ЕстьВключенные = Неопределено Тогда
				ЕстьВключенные = Ложь;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьВключенные = Неопределено Тогда // Группа это вариант.
			ГруппаИлиВариант.СкрытОтбором = ОтборВключен И ГруппаИлиВариант.Автор <> ОтборАвтор;
		Иначе // Это группа.
			ГруппаИлиВариант.СкрытОтбором = ЕстьВключенные;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоВариантовОтчета

&НаКлиенте
Процедура ДеревоВариантовОтчетаПриАктивизацииСтроки(Элемент)
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		ВариантОписание = "";
	Иначе
		ВариантОписание = Вариант.Описание;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьВариантДляИзменения();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;

	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		Возврат;
	КонецЕсли;

	Если Вариант.ИндексКартинки = 4 Тогда
		ТекстВопроса = "Снять с ""%1"" пометку на удаление?";
	Иначе
		ТекстВопроса = "Пометить ""%1"" на удаление?";
	КонецЕсли;
	ТекстВопроса = СтрШаблон(ТекстВопроса, Вариант.Наименование);

	ДополнительныеПараметры	= Новый Структура;
	ДополнительныеПараметры.Вставить("Вариант", Вариант);
	Обработчик				= Новый ОписаниеОповещения("ДеревоВариантовОтчетаПередУдалениемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьЛичныеВариантыОтчетовДругихАвторов(Команда)
	ПоказыватьЛичныеВариантыОтчетовДругихАвторов					= Не ПоказыватьЛичныеВариантыОтчетовДругихАвторов;
	Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Пометка	= ПоказыватьЛичныеВариантыОтчетовДругихАвторов;
	Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Пометка	= ПоказыватьЛичныеВариантыОтчетовДругихАвторов;

	ЗаполнитьСписокВариантов();

	Для Каждого ГруппаДерева Из ДеревоВариантовОтчета.ПолучитьЭлементы() Цикл
		Если ГруппаДерева.СкрытОтбором = Ложь Тогда
			Элементы.ДеревоВариантовОтчета.Развернуть(ГруппаДерева.ПолучитьИдентификатор(), Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьСписокВариантов();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчета.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаПредставление.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаАвтор.Имя);

	ОтборЭлемента					= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ДеревоВариантовОтчета.СкрытОтбором");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаПредставление.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаАвтор.Имя);

	ОтборЭлемента					= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ДеревоВариантовОтчета.АвторТекущийПользователь");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.МоиВариантыОтчетовЦвет);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КлючВарианта", Вариант.КлючВарианта);
	Если Вариант.ИндексКартинки = 4 Тогда
		ТекстВопроса = "Выбранный вариант отчета помечен на удаление.
		|Выбрать этот варианта отчета?";
		Обработчик = Новый ОписаниеОповещения("ВыбратьИЗакрытьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ВыбратьИЗакрытьЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрытьЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Закрыть(Новый ВыборНастроек(ДополнительныеПараметры.КлючВарианта));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариантДляИзменения()
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Если Не ПравоИзмененияВарианта(Вариант, ПолныеПраваНаВарианты) Тогда
		ТекстПредупреждения = "Недостаточно прав для изменения варианта ""%1"".";
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);

		Возврат;
	КонецЕсли;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Вариант.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередУдалениемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНаСервере(ДополнительныеПараметры.Вариант.Ссылка, ДополнительныеПараметры.Вариант.ИндексКартинки);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПравоИзмененияВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь;
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВариантов()
	ТекущийКлючВарианта = КлючВарианта;
	Если ЗначениеЗаполнено(Элементы.ДеревоВариантовОтчета.ТекущаяСтрока) Тогда
		ТекущаяСтрокаДерева = ДеревоВариантовОтчета.НайтиПоИдентификатору(Элементы.ДеревоВариантовОтчета.ТекущаяСтрока);
		Если ЗначениеЗаполнено(ТекущаяСтрокаДерева.КлючВарианта) Тогда
			ТекущийКлючВарианта = ТекущаяСтрокаДерева.КлючВарианта;
		КонецЕсли;
	КонецЕсли;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	            	  |	ВариантыОтчетов.Ссылка КАК Ссылка,
	            	  |	ВариантыОтчетов.Наименование КАК Наименование,
	            	  |	ВариантыОтчетов.КлючВарианта КАК КлючВарианта,
	            	  |	ВЫБОР
	            	  |		КОГДА ПОДСТРОКА(ВариантыОтчетов.Описание, 1, 1) = """"
	            	  |			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.ПредопределенныйВариант.Описание КАК СТРОКА(1000))
	            	  |		ИНАЧЕ ВЫРАЗИТЬ(ВариантыОтчетов.Описание КАК СТРОКА(1000))
	            	  |	КОНЕЦ КАК Описание,
	            	  |	ВЫБОР
	            	  |		КОГДА НЕ ВариантыОтчетов.Пользовательский
	            	  |				И НЕ ВариантыОтчетов.ВидимостьПоУмолчаниюПереопределена
	            	  |			ТОГДА ЕСТЬNULL(ВариантыОтчетов.ПредопределенныйВариант.ВидимостьПоУмолчанию, ЛОЖЬ)
	            	  |		ИНАЧЕ ВариантыОтчетов.ВидимостьПоУмолчанию
	            	  |	КОНЕЦ КАК ВидимостьПоУмолчанию,
	            	  |	ВариантыОтчетов.Автор КАК Автор,
	            	  |	ВариантыОтчетов.ТолькоДляАвтора КАК ТолькоДляАвтора,
	            	  |	ВариантыОтчетов.Пользовательский КАК Пользовательский,
	            	  |	ВариантыОтчетов.ПометкаУдаления КАК ПометкаУдаления,
	            	  |	ВариантыОтчетов.ПредопределенныйВариант КАК ПредопределенныйВариант
	            	  |ПОМЕСТИТЬ втВарианты
	            	  |ИЗ
	            	  |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	            	  |ГДЕ
	            	  |	ВариантыОтчетов.Отчет = &Отчет
	            	  |	И НЕ(НЕ ВариантыОтчетов.Пользовательский = ИСТИНА
	            	  |				И НЕ ВариантыОтчетов.ПометкаУдаления = ЛОЖЬ)
	            	  |	И НЕ(НЕ ВариантыОтчетов.ТолькоДляАвтора = ЛОЖЬ
	            	  |				И НЕ ВариантыОтчетов.Автор = &ТекущийПользователь)
	            	  |	И НЕ ВариантыОтчетов.ПредопределенныйВариант В (&ОтключенныеВариантыПрограммы)
	            	  |;
	            	  |
	            	  |////////////////////////////////////////////////////////////////////////////////
	            	  |ВЫБРАТЬ
	            	  |	ВариантыОтчетов.Ссылка КАК Ссылка,
	            	  |	ВариантыРазмещение.Использование КАК Использование,
	            	  |	ВариантыРазмещение.Подсистема КАК Подсистема
	            	  |ПОМЕСТИТЬ втРазмещениеАдминистратора
	            	  |ИЗ
	            	  |	втВарианты КАК ВариантыОтчетов
	            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Размещение КАК ВариантыРазмещение
	            	  |		ПО ВариантыОтчетов.Ссылка = ВариантыРазмещение.Ссылка
	            	  |;
	            	  |
	            	  |////////////////////////////////////////////////////////////////////////////////
	            	  |ВЫБРАТЬ
	            	  |	ВариантыОтчетов.Ссылка КАК Ссылка,
	            	  |	РазмещениеКонфигурации.Подсистема КАК Подсистема
	            	  |ПОМЕСТИТЬ втРазмещениеРазработчика
	            	  |ИЗ
	            	  |	втВарианты КАК ВариантыОтчетов
	            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Размещение КАК РазмещениеКонфигурации
	            	  |		ПО (ВариантыОтчетов.Пользовательский = ЛОЖЬ)
	            	  |			И ВариантыОтчетов.ПредопределенныйВариант = РазмещениеКонфигурации.Ссылка
	            	  |
	            	  |ОБЪЕДИНИТЬ ВСЕ
	            	  |
	            	  |ВЫБРАТЬ
	            	  |	ВариантыОтчетов.Ссылка,
	            	  |	РазмещениеРасширений.Подсистема
	            	  |ИЗ
	            	  |	втВарианты КАК ВариантыОтчетов
	            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений.Размещение КАК РазмещениеРасширений
	            	  |		ПО (ВариантыОтчетов.Пользовательский = ЛОЖЬ)
	            	  |			И ВариантыОтчетов.ПредопределенныйВариант = РазмещениеРасширений.Ссылка
	            	  |;
	            	  |
	            	  |////////////////////////////////////////////////////////////////////////////////
	            	  |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	            	  |	ЕСТЬNULL(РазмещениеАдминистратора.Ссылка, РазмещениеРазработчика.Ссылка) КАК Ссылка,
	            	  |	ЕСТЬNULL(РазмещениеАдминистратора.Подсистема, РазмещениеРазработчика.Подсистема) КАК Подсистема,
	            	  |	ЕСТЬNULL(РазмещениеАдминистратора.Использование, ИСТИНА) КАК Использование,
	            	  |	ВЫБОР
	            	  |		КОГДА РазмещениеАдминистратора.Ссылка ЕСТЬ NULL
	            	  |			ТОГДА ИСТИНА
	            	  |		ИНАЧЕ ЛОЖЬ
	            	  |	КОНЕЦ КАК ЭтоНастройкаРазработчика
	            	  |ПОМЕСТИТЬ втРазмещениеВариантов
	            	  |ИЗ
	            	  |	втРазмещениеАдминистратора КАК РазмещениеАдминистратора
	            	  |		ПОЛНОЕ СОЕДИНЕНИЕ втРазмещениеРазработчика КАК РазмещениеРазработчика
	            	  |		ПО РазмещениеАдминистратора.Ссылка = РазмещениеРазработчика.Ссылка
	            	  |			И РазмещениеАдминистратора.Подсистема = РазмещениеРазработчика.Подсистема
	            	  |ГДЕ
	            	  |	ЕСТЬNULL(РазмещениеАдминистратора.Использование, ИСТИНА)
	            	  |;
	            	  |
	            	  |////////////////////////////////////////////////////////////////////////////////
	            	  |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	            	  |	Размещение.Ссылка КАК Ссылка,
	            	  |	МАКСИМУМ(ЕСТЬNULL(ЛичныеНастройки.Видимость, Варианты.ВидимостьПоУмолчанию)) КАК ВидимостьВПанелиОтчетов
	            	  |ПОМЕСТИТЬ втВидимость
	            	  |ИЗ
	            	  |	втРазмещениеВариантов КАК Размещение
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиВариантовОтчетов КАК ЛичныеНастройки
	            	  |		ПО Размещение.Подсистема = ЛичныеНастройки.Подсистема
	            	  |			И Размещение.Ссылка = ЛичныеНастройки.Вариант
	            	  |			И (ЛичныеНастройки.Пользователь = &ТекущийПользователь)
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ втВарианты КАК Варианты
	            	  |		ПО Размещение.Ссылка = Варианты.Ссылка
	            	  |
	            	  |СГРУППИРОВАТЬ ПО
	            	  |	Размещение.Ссылка
	            	  |;
	            	  |
	            	  |////////////////////////////////////////////////////////////////////////////////
	            	  |ВЫБРАТЬ
	            	  |	Варианты.Ссылка КАК Ссылка,
	            	  |	Варианты.Наименование КАК Наименование,
	            	  |	Варианты.КлючВарианта КАК КлючВарианта,
	            	  |	Варианты.ВидимостьПоУмолчанию КАК ВидимостьПоУмолчанию,
	            	  |	Варианты.Автор КАК Автор,
	            	  |	Варианты.ТолькоДляАвтора КАК ТолькоДляАвтора,
	            	  |	Варианты.Пользовательский КАК Пользовательский,
	            	  |	Варианты.ПометкаУдаления КАК ПометкаУдаления,
	            	  |	ВЫБОР
	            	  |		КОГДА Варианты.ПометкаУдаления = ИСТИНА
	            	  |			ТОГДА 3
	            	  |		КОГДА Видимость.ВидимостьВПанелиОтчетов = ИСТИНА
	            	  |			ТОГДА 1
	            	  |		ИНАЧЕ 2
	            	  |	КОНЕЦ КАК НомерГруппы,
	            	  |	Варианты.Описание КАК Описание,
	            	  |	ВЫБОР
	            	  |		КОГДА Варианты.ПометкаУдаления
	            	  |			ТОГДА 4
	            	  |		КОГДА Варианты.Пользовательский
	            	  |			ТОГДА 3
	            	  |		ИНАЧЕ 5
	            	  |	КОНЕЦ КАК ИндексКартинки,
	            	  |	ВЫБОР
	            	  |		КОГДА Варианты.Автор = &ТекущийПользователь
	            	  |			ТОГДА ИСТИНА
	            	  |		ИНАЧЕ ЛОЖЬ
	            	  |	КОНЕЦ КАК АвторТекущийПользователь
	            	  |ИЗ
	            	  |	втВарианты КАК Варианты
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ втВидимость КАК Видимость
	            	  |		ПО Варианты.Ссылка = Видимость.Ссылка";

	Запрос.УстановитьПараметр("Отчет",							ОтчетИнформация.Отчет);
	Запрос.УстановитьПараметр("ТекущийПользователь",			ТекущийПользователь);
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы",	ВариантыОтчетовСеверПовтИсп.ОтключенныеВариантыПрограммы());

	Если ПоказыватьЛичныеВариантыОтчетовДругихАвторов Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И НЕ(НЕ ВариантыОтчетов.ТолькоДляАвтора = ЛОЖЬ
		|				И НЕ ВариантыОтчетов.Автор = &ТекущийПользователь)", "");
	КонецЕсли;

	ТаблицаВариантов = Запрос.Выполнить().Выгрузить();

	// Добавить предопределенные варианты внешнего отчета в таблицу вариантов (для сортировки при добавлении в дерево).
	Если ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний Тогда
		Попытка
			ОтчетОбъект = ВнешниеОтчеты.Создать(ОтчетИнформация.ОтчетИмя);
		Исключение
			ВариантыОтчетовСервер.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка,
				СтрШаблон("Не удалось получить список предопределенных вариантов
						|внешнего отчета ""%1"":", ОтчетИнформация.ОтчетИмя) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			Возврат;
		КонецПопытки;

		Если ОтчетОбъект.СхемаКомпоновкиДанных <> Неопределено Тогда
			Для Каждого ВариантНастроекКД Из ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек Цикл
				Вариант								= ТаблицаВариантов.Добавить();
				Вариант.НомерГруппы					= 1;
				Вариант.КлючВарианта				= ВариантНастроекКД.Имя;
				Вариант.Наименование				= ВариантНастроекКД.Представление;
				Вариант.ИндексКартинки				= 5;
				Вариант.АвторТекущийПользователь	= Ложь;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	ТаблицаВариантов.Сортировать("НомерГруппы ВОЗР, Наименование ВОЗР");
	ДеревоВариантовОтчета.ПолучитьЭлементы().Очистить();
	ГруппыДерева = Новый Соответствие;
	ГруппыДерева.Вставить(1, ДеревоВариантовОтчета.ПолучитьЭлементы());

	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.КлючВарианта) Тогда
			Продолжить;
		КонецЕсли;
		НаборСтрокДерева = ГруппыДерева.Получить(СтрокаТаблицы.НомерГруппы);
		Если НаборСтрокДерева = Неопределено Тогда
			ГруппаДерева				= ДеревоВариантовОтчета.ПолучитьЭлементы().Добавить();
			ГруппаДерева.НомерГруппы	= СтрокаТаблицы.НомерГруппы;
			Если СтрокаТаблицы.НомерГруппы = 2 Тогда
				ГруппаДерева.Наименование	= "Скрытые в панелях отчетов";
				ГруппаДерева.ИндексКартинки	= 0;
				ГруппаДерева.КартинкаАвтора	= -1;
			ИначеЕсли СтрокаТаблицы.НомерГруппы = 3 Тогда
				ГруппаДерева.Наименование	= "Помеченные на удаление";
				ГруппаДерева.ИндексКартинки = 1;
				ГруппаДерева.КартинкаАвтора = -1;
			КонецЕсли;
			НаборСтрокДерева = ГруппаДерева.ПолучитьЭлементы();
			ГруппыДерева.Вставить(СтрокаТаблицы.НомерГруппы, НаборСтрокДерева);
		КонецЕсли;

		Вариант = НаборСтрокДерева.Добавить();
		ЗаполнитьЗначенияСвойств(Вариант, СтрокаТаблицы);
		Если Вариант.КлючВарианта = ТекущийКлючВарианта Тогда
			Элементы.ДеревоВариантовОтчета.ТекущаяСтрока = Вариант.ПолучитьИдентификатор();
		КонецЕсли;
		Вариант.КартинкаАвтора = ?(Вариант.ТолькоДляАвтора, -1, 0);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьВариантНаСервере(Ссылка, ИндексКартинки)
	ВариантОбъект		= Ссылка.ПолучитьОбъект();
	ПометкаУдаления		= Не ВариантОбъект.ПометкаУдаления;
	Пользовательский	= ВариантОбъект.Пользовательский;
	ВариантОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	ИндексКартинки		= ?(ПометкаУдаления, 4, ?(Пользовательский, 3, 5));
КонецПроцедуры
