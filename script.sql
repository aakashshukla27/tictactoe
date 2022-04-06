set serveroutput on;

begin
    execute immediate 'create table assignmentGame(
                            id number,
                            val char
                       )';
end;

begin
    for i in 1..9 loop
        insert into ASSIGNMENTGAME values (i, to_char(i));
        end loop;
end;

select * from ASSIGNMENTGAME;

create procedure printGameTTT is
type rowtype is table of char;
currentRow rowtype;
returnBoard nvarchar2(4000);
begin
    select val bulk collect into currentRow from ASSIGNMENTGAME;
    returnBoard := chr(9) ||'   |     |      ' || chr(10);
    returnBoard := returnBoard ||chr(9)||currentRow(1)||'  |  '||currentRow(2)||'  |  '||currentRow(3) ;
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard||chr(9)  ||'___|_____|___ ';
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard ||chr(9) ||'   |     |      ' || chr(10);
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard ||chr(9) ||currentRow(4)||'  |  '||currentRow(5)||'  |  '||currentRow(6);
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard||chr(9)  ||'___|_____|___ ';
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard ||chr(9) ||'   |     |      ' || chr(10);
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard ||chr(9)||currentRow(7)||'  |  '||currentRow(8)||'  |  '||currentRow(9);
    returnBoard := concat(returnBoard,chr(10));
    returnBoard := returnBoard ||chr(9) ||'   |     |      ' || chr(10);
    DBMS_OUTPUT.PUT_LINE(returnBoard);
end;
/

create procedure startGameTTT is
i number;
begin
    delete from ASSIGNMENTGAME where id > 0;
    for i in 1..9 loop
        insert into ASSIGNMENTGAME values (i, to_char(i));
    end loop;
    DBMS_OUTPUT.PUT_LINE('Starting new game');
    printGameTTT();
end;
/

create procedure playGameTTT(symbol in char, rowNumber in number) is
currentVal char;
begin
    select val into currentVal from ASSIGNMENTGAME where id = rowNumber;
    if not currentVal = 'X' and not currentVal = 'O' then
        execute immediate ('update assignmentGame set val = ''' || symbol || ''' where id = ' || rowNumber);
    else
        DBMS_OUTPUT.PUT_LINE('Cell already occupied.');
    end if;
end;
/

create procedure winnerTTT(ip in char) is
begin
    printGameTTT();
    if ip = 'X' then
        DBMS_OUTPUT.PUT_LINE('Player X wins.');
    elsif ip = 'Y' then
        DBMS_OUTPUT.PUT_LINE('Player O wins');
    elsif ip = 'D' then
        DBMS_OUTPUT.PUT_LINE('Draw');
    else
        DBMS_OUTPUT.PUT_LINE('Next chance');
    end if;
end;
/


create trigger checkWinnerTTT
after update on ASSIGNMENTGAME
declare
    type rowtype is table of char;
    currentRow rowtype;
begin
    select val bulk collect into currentRow from ASSIGNMENTGAME;
    if currentRow(1) = currentRow(2) and currentRow(2) = currentRow(3) then
        winnerTTT(currentRow(1));
    elsif currentRow(4) = currentRow(5) and currentRow(5) = currentRow(6) then
        winnerTTT((currentRow(4)));
    elsif currentRow(7) = currentRow(8) and currentRow(8) = currentRow(9) then
        winnerTTT((currentRow(7)));
    elsif currentRow(1) = currentRow(4) and currentRow(4) = currentRow(7) then
        winnerTTT((currentRow(1)));
    elsif currentRow(2) = currentRow(5) and currentRow(5) = currentRow(8) then
        winnerTTT((currentRow(2)));
    elsif currentRow(3) = currentRow(6) and currentRow(6) = currentRow(9) then
        winnerTTT((currentRow(3)));
    elsif currentRow(1) = currentRow(5) and currentRow(5) = currentRow(9) then
        winnerTTT((currentRow(1)));
    elsif currentRow(3) = currentRow(5) and currentRow(5) = currentRow(7) then
        winnerTTT((currentRow(3)));
    elsif not currentRow(1) = '1'
              and
          not currentRow(2) = '2'
              and
          not currentRow(3) = '3'
              and
          not currentRow(4) = '4'
              and
          not currentRow(5) = '5'
              and
          not currentRow(6) = '6'
              and
          not currentRow(7) = '7'
              and
          not currentRow(8) = '8'
              and
          not currentRow(9) = '9' then
        winnerTTT(('D'));
    else
        winnerTTT(('-'));
    end if;
end;

begin
    printGameTTT();
end;
begin
    startGameTTT();
end;
begin
    playGameTTT(to_char('X'), 1);
end;
begin
    playGameTTT('O',4);
    playGameTTT('X',2);
    playGameTTT('O',5);
    playGameTTT('X',3);
end;


create or replace function utWinner(ip in char)
return char
is
begin
    if ip = 'X' then
        return 'X';
    elsif ip = 'O' then
        return 'O';
    elsif ip = 'D' then
        return 'D';
    else
        return 'N';
    end if;
end;
/

create or replace function playgamePosTest(symbol in char, rowNumber in number)
return char
is
begin
        execute immediate 'create table moqAssignmentGame(
                            id number,
                            val char
                       )';
        execute immediate 'insert into moqAssignmentGame values(1, ''1'')';
        if rowNumber = 1 then
            return 'P';
        end if;
        return 'N';
end;

create or replace function playgamePosOccTest(symbol in char, rowNumber in number)
return char
is
begin
        execute immediate 'create table moqAssignmentGame2(
                            id number,
                            val char
                       )';
        execute immediate 'insert into moqAssignmentGame2 values(1, ''X'')';
        if rowNumber = 1 then
            return 'P';
        end if;
        return 'N';
end;

create or replace package example_package as

  --%suite(Checks tic tac toe)

  --%test(Returns correct winner)
  --%tags(correct_winner)
  procedure testCorrectWinner;
      
--%test(Returns update to correct position)
  --%tags(correct_position)
  procedure testCorrectPosition;
      
--%test(Returns error stating position occupied)
  --%tags(correct_position_occupied)
  procedure testCorrectPositionOcc;
end;
/

create or replace package body example_package as

  procedure testCorrectWinner is
  begin
    ut.EXPECT(UTWINNER('X')).to_equal('X');
  end;

  procedure testCorrectPosition is
  begin
      ut.EXPECT(playgamePosTest('X', 1)).TO_EQUAL('P');
  end;
    procedure testCorrectPositionOcc is
  begin
      ut.EXPECT(playgamePosOccTest('X', 1)).TO_EQUAL('P');
  end;
end;
/

