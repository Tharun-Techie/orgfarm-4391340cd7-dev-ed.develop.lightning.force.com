// Example Batch Execution
public class StoryBatch implements Database.Batchable<Integer>, Database.AllowsCallouts {
    public List<Integer> start(Database.BatchableContext bc) {
        return GeneralMethods.getTopStoriesList();
    }
    public void execute(Database.BatchableContext bc, List<Integer> scope) {
        for(Integer id : scope) {
            System.debug(GeneralMethods.getResponse(String.valueOf(id)));
        }
    }
    public void finish(Database.BatchableContext bc) {}
}