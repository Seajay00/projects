
Create Procedure [dbo].[P2_Drill]

	@XmlParam xml = null,
	@DrillDownField varchar(max) = null,
	@DrillDownParams varchar(max) = null,
	@UserID int

	AS

BEGIN

	declare @TradePoint int
	
	declare @Region varchar(500),
			@Territory varchar(500)

	DECLARE @Params TABLE ([Name] varchar(max), 
						   [From] varchar(max), 
						   [To] varchar(max), 
						   [Value] varchar(max))

	INSERT INTO @Params ([Name], 
						 [From], 
						 [To], 
						 [Value])

	EXEC crm_repGetParams @XML = @XmlParam;
		
	declare @DrillParams table ([Name] varchar(max), [From] varchar(max), [To] varchar(max), [Value] varchar(max))



IF nullif(@DrillDownField,'') is null 
	BEGIN
		
---------------------------------Основной вывод --------------------------------------

		select distinct
	
	Задачи_кат33.ExtParam75NativeValue, 
	Задачи_кат33.ExtParam75Value,
	(
		select 
			count(t1.TaskID) Количество_просроченных_задач_категории_33
		from 
			TasksInSubcat33Denormalized t1
		where 
			t1.StateId in (1,31) 
			and t1.IsOverdue = 1
			and t1.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue		
	) as Просроченные_задачи,

	(
		select 
			count(t1.TaskID) 
		from 
			TasksInSubcat33Denormalized t1
		where 
			t1.StateId in (1,31) 
			and datepart(wk, t1.OrderedTime) = (datepart(wk, getdate()))
			and t1.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue		
	) as Задачи_истекающие_на_тек_неделе,

	(
		select 
			count(t1.TaskID) 
		from 
			TasksInSubcat33Denormalized t1
		where 
			t1.StateId in (1,31) 
			and datepart(wk, t1.OrderedTime) = (datepart(wk, getdate())+1)
			and t1.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue		
	) as Задачи_истекающие_на_след_неделе,

		(
		select 
			count(t1.TaskID) 
		from 
			TasksInSubcat33Denormalized t1
		where 
			t1.StateId in (1,31) 
			and datepart(wk, t1.OrderedTime) >= (datepart(wk, getdate())+2)
			and t1.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue		
	   ) as Задачи_истекающие_через_неделю ,


		
		(select count(distinct Перенос_срока.TaskID) 
		from TaskOrderedDateAudit Перенос_срока
			join
			TasksInSubcat33Denormalized t33 on  Перенос_срока.TaskID=t33.TaskID 
		where 
			t33.StateId in (1,31) and
			Перенос_срока.UserID <> 3 and 
			t33.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue
		 ) as  Перенесенные_задачи
		,
		(select count(TaskID) 
		from TasksInSubcat33Denormalized t11
		where 
			t11.ExtParam75NativeValue = Задачи_кат33.ExtParam75NativeValue and
			t11.StateID=4 and 
			StateFinishWork=1
        ) as Выполненные_задачи

from
	TasksInSubcat33Denormalized Задачи_кат33
left join
	TasksInSubcat11Denormalized t11
		on Задачи_кат33.ExtParam75NativeValue = t11.TaskID and t11.StateId = 9

where
	Задачи_кат33.StateId not in (2, 38, 40, 41) 
---------------------------------------------------------------------------------

	END
ELSE
	BEGIN
		
		INSERT INTO @DrillParams ([Name], [From], [To], [Value])
		
          EXEC crm_repGetParams @XML = @DrillDownParams

		SET @TradePoint = (select [Value] from @DrillParams where Name = 'ExtParam75NativeValue' )
	    
---------------------------------- Детализация ------------------------------------


select 
   (
   select
		tt33.TaskID
   from
		TasksInSubcat33Denormalized tt33
   left join
		TasksInSubcat11Denormalized t11
	on 
	tt33.ExtParam75NativeValue = t11.TaskID and t11.StateId = 9
	where tt33.StateId not in (2, 38, 40, 41)
	and tt33.TaskID=t33.TaskID
	) as Номер_задачи,
t33.StateName,
t33.TaskText,
t33.ResponsiblePerformerId,
t33.OrderedTime,
	(
select 
	count(Перенос.NewDate) 
from TaskOrderedDateAudit Перенос
	join TasksInSubcat33Denormalized t333 on t333.TaskID=Перенос.TaskID
where 
	UserID<>3 and 
	t333.StateId<>38 and
	t333.TaskID=t33.TaskID
group by Перенос.TaskID 
	) as Количество_переносов_срока,
t33.ExtParam75NativeValue
from 
TasksInSubcat33Denormalized t33
where 
t33.StateId in (1,31)
and t33.IsOverdue = 1
and t33.ExtParam75NativeValue = @TradePoint
order by t33.OrderedTime

----------------------------------------------------------------
		 
	END
END
