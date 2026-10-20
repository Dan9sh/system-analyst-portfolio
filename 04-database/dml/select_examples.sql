-- 1. Получить user_id и push_token всех активных устройств на платформе ios.

select push_token, ud.user_id 
from user_device ud 
where ud.is_active is true and platform = 'ios'

-- 2. Получить список всех шаблонов уведомлений, которые принадлежат сервису с конкретным названием (например, биллинг) - используйте JOIN с таблицей service по имени, а не по id.

select nt."name" , ntt.notification_text 
from notification_template_text ntt  
join notification_template nt on ntt.notification_template_id =nt.id
join service s on nt.service_id = s.id 
where s."name" = 'billing'

-- 3. Посчитать, сколько всего разных (уникальных) клиентов дали согласие хотя бы на один сервис.

select count(distinct user_id)
from user_service us 
where us.is_allowed is true

-- 4. Найти клиентов, которые не дали согласие ни на один сервис вообще - то есть для них в user_service нет ни одной строки с is_allowed = true.

select us.user_id 
from user_service us 
where us.user_id not in (select user_id
from user_service us 
where us.is_allowed is true)

-- 5. Получить список категорий, у которых одновременно включена проверка

select c.category 
from category c 
where c.requires_consent is true and quiet_hours is true

-- 6. Для каждого сервиса посчитать, сколько шаблонов уведомлений он создал, показать только топ-5 сервисов по количеству шаблонов, отсортировав по убыванию.

select s.name, count(nt.service_id)
from notification_template nt 
join  service s  on nt.service_id = s.id 
group by nt.service_id, s."name" 
order by count desc
limit 5

-- 7. Получить все записи из outbox, у которых финальная попытка доставки (delivery_attempts) завершилась статусом failed и при этом была фолбэк-попыткой (is_fallback = true), вместе с телефоном клиента - потребуется соединить три таблицы.

select o.*, phone
from outbox o 
join delivery_attempt da on o.id = da.outbox_id
join "user" u on u.user_id = o.user_id 
where da.is_fallback is true and da.status = 'failed'

-- 8. Посчитать, сколько уведомлений (записей в outbox) было создано у каждого клиента за последние 30 дней.

select user_id, count(o.user_id )
from outbox o 
where o.created_dt >= now() - interval '30 days'
group by o.user_id

-- 9. Найти коды шаблонов (template_code), у которых есть текст сразу для обоих каналов - и push, и sms одновременно.

select nt.template_id, count(ntt.channel ) as "кол-во каналов"
from notification_template nt 
join notification_template_text ntt on nt.id = ntt.notification_template_id
group by nt.template_id 
having count(ntt.channel ) >1
-- P.S. Понимаю, что решение не совсем верное, но цифры сходятся
