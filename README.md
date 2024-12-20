## Создание CTF задачи: Broken Merkle tree

### Легенда:
Студент с прошлого года решил в качестве проекта по курсу "введение в blockchain" создать свою CTF задачу, однако он допустил в ней ошибку.

## Условие задачи
Вам предоставлен смарт-контракт MerkleTreeTask. Данный контракт обладает тремя методами

1. Метод generateTest генерирует (псевдослучайно) по какой-то строке (seed) набор "транзакций" - строк, для которых требуется вычислить merkle root. Выставляет флаг isSolved = false.
2. Метод submit который принимает Ваш merkle root и сравнивает его с ответом, если задача решена, будет выставлен флаг isSolved = true.
3. Метод solved возвращает значение флага isSolved.

Вам требуется написать свой смарт-контракт Soltion, вызвать в нем MerkleTreeTask, сгенерировать какой-то набор транзакций, найти для них merkle root и загузить его в MerkleTreeTask.
Однако, студент допустил ошибку при реализации собственного алгоритма нахождения merkle root, так что если Вы хотите решить данную задачу, Вам потребуется найти такой набор входных данных, на котором алгоритм студента работает без ошибок.


## Решение задачи:
1. Студент допустил ошибку при вычислении хешей на уровнях merkle tree с нечетным количеством узлов.
2. Псевдослучайная генерация тестов работает следующим образом:
    Генерируется массив строк вида `"Transaction {i}"` для каждого `i` в `{1, ..., base + (len(seed) % mod)}`.
    Где `base` и `mod` - магические константы в реализации, а `len(seed)` - длина строки, которую студент указал в качестве начальной.
3. Для решения задачи студенту необходимо подобрать строку такой длины, чтобы значение `base + (len(seed) % mod)` являлось степенью двойки, тогда в алгоритме автора не возникнет ни одного уровня дерева с нечетным количеством листов и merkle root будет посчитан правильно.

## Возможные улучшения
1. Усложнение алгоритма генерации. Можно изменить алгоритм псевдослучайной генерации тестов, например привязать его к хэшу `seed` строки. Также можно выдавать хеши сгенерированных записей.
2. Добавить в генерацию "соль" для того, чтобы нельзя было всем студентам отправлять один и тот же хэш.
3. Сделать генерацию тестов платной или слишком долгой, чтобы стимулировать студентов решать задачу аналитически.
4. Реализовать другие алгоритмы работы с merkle tree.
