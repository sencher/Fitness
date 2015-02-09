/**
 * Created by M1.SenCheR on 05.11.14.
 */
package vo {
import utils.Utils;

public class ClientVisitsVO {
    public var id:int;
    public var visitDates:Vector.<Date> = new <Date>[];

    public var last_visit:Date;
    public var visits:int;
    private var client:ClientVO;
    public var client_stage:int;

    public function ClientVisitsVO(client:ClientVO) {
        this.client = client;
        this.id = client.cardId;
    }

    public function updateCounters():void {
        visits = visitDates.length;
        last_visit = visits ? visitDates[visitDates.length - 1] : client.abonement.reg_day;
        client_stage = Math.abs(Utils.countDays(client.abonement.reg_day));
    }
}
}
