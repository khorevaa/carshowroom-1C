﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.Срок.Подсказка = Метаданные.РегистрыСведений.СведенияОПользователях.Ресурсы.СрокДействия.Подсказка;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Просрочка = ВладелецФормы.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода;
	Срок      = ВладелецФормы.СрокДействия;

	Если ВладелецФормы.СрокДействияНеОграничен Тогда
		ВидСрока		= "НеОграничен";
		ТекущийЭлемент	= Элементы.ВидСрокаНеОграничен;
	ИначеЕсли ЗначениеЗаполнено(Срок) Тогда
		ВидСрока		= "ДоДаты";
		ТекущийЭлемент	= Элементы.ВидСрокаДоДаты;
	ИначеЕсли ЗначениеЗаполнено(Просрочка) Тогда
		ВидСрока		= "Просрочка";
		ТекущийЭлемент	= Элементы.ВидСрокаПросрочка;
	Иначе
		ВидСрока		= "НеУказан";
		ТекущийЭлемент	= Элементы.ВидСрокаНеУказан;
	КонецЕсли;

	ОбновитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСрокаПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ОчиститьСообщения();

	Если ВидСрока = "ДоДаты" Тогда
		Если Не ЗначениеЗаполнено(Срок) Тогда
			БазоваяПодсистемаКлиентСервер.СообщитьПользователю("Дата не указана.",, "Срок");

			Возврат;
		ИначеЕсли Срок <= НачалоДня(БазоваяПодсистемаКлиент.ДатаСеанса()) Тогда
			БазоваяПодсистемаКлиентСервер.СообщитьПользователю("Ограничение должно быть до завтра или более.",, "Срок");
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ВладелецФормы.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода	= Просрочка;
	ВладелецФормы.СрокДействия									= Срок;
	ВладелецФормы.СрокДействияНеОграничен						= (ВидСрока = "НеОграничен");

	Закрыть();
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбновитьДоступность()
	Если ВидСрока = "ДоДаты" Тогда
		Элементы.Срок.АвтоОтметкаНезаполненного	= Истина;
		Элементы.Срок.Доступность				= Истина;
	Иначе
		Элементы.Срок.АвтоОтметкаНезаполненного	= Ложь;
		Срок									= Неопределено;
		Элементы.Срок.Доступность				= Ложь;
	КонецЕсли;

	Если ВидСрока <> "Просрочка" Тогда
		Просрочка = 0;
	ИначеЕсли Просрочка = 0 Тогда
		Просрочка = 60;
	КонецЕсли;
	Элементы.Просрочка.Доступность = ВидСрока = "Просрочка";
КонецПроцедуры
