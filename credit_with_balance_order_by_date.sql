THIS QUERY WILL GET LIST OF CREDIT TXN
ORDER BY DATE DESC
OUTPUT:
TOTAL : 20
id	date   		amount 		balance
1   10/2/2014	5			0
3	09/2/2014	5			5
2	08/2/2014	10			10


Explanation:
	The problem we need to get the list in the right order with correct total_utilized value and limit without problem

	The sub query "subq" get all results base on the normal order ORDER BY ASC
	doing this solved the problem of wrong calcualtion from wrong order ORDER DESC

STEP BY STEP( ORDER BY `date_created` ASC )
id	date   		amount 		@total_utilized		balance		( @balance - @total_utilized )
2	08/2/2014	10			10					20			10
3	09/2/2014	5			15					20			15
1   10/2/2014	5			20					20			0

	WRONG: ORDER BY date_created DESC
	id	date   		amount 		@total_utilized		balance		( @balance - @total_utilized )
	1   10/2/2014	5			5					20			0
	3	09/2/2014	5			10					20			15
	2	08/2/2014	10			20					20			10

Then ReOrder the result with LIMIT values
id	date   		amount 		@total_utilized		balance		( @balance - @total_utilized )
1   10/2/2014	5			20					20			0
3	09/2/2014	5			15					20			15
2	08/2/2014	10			10					20			10

		$db->query("SET @total_utilized := 0;");
		$db->query("SET @balance :=  (SELECT total_credit FROM credits c WHERE c.credit_ID = '".$credit_ID."')");
		$query = " SELECT * FROM ( (  SELECT *, @total_utilized := @total_utilized + amount, ( @balance - @total_utilized ) AS balance FROM `credit_transactions` WHERE credit_ID = '".$credit_ID."' ORDER BY `date_created` ASC ) AS subq ) ORDER BY `date_created` DESC  LIMIT $start, $limit";
