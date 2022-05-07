import { AzureFunction, Context, HttpRequest } from '@azure/functions';
import { ServiceBusClient } from '@azure/service-bus';
import { EventHubProducerClient } from '@azure/event-hubs';

export const handler: AzureFunction = async (context: Context, req: HttpRequest): Promise<void> => {
	try {
		await sendServiceBusMessage()
		await publishToEventHubs()
		context.res = {
			body: `Hello, World!`
		};
	} catch (err) {
		context.res = {
			status: 400,
			body: `An error occurred: ${err}`
		};
	}
};

async function sendServiceBusMessage() {
	const serviceBusClient = new ServiceBusClient(process.env.SERVICE_BUS_CONNECTION!);
	const sender = serviceBusClient.createSender(process.env.SERVICE_BUS_QUEUE!);
	const message = { body: "Sample body for Service Bus" };
	return sender.sendMessages(message);
}

async function publishToEventHubs() {
	const producerClient = new EventHubProducerClient(process.env.EVENT_HUBS_CONNECTION!, process.env.EVENT_HUBS_NAME!);
	const eventDataBatch = await producerClient.createBatch();
	eventDataBatch.tryAdd({ body: "Sample body for Event Hubs" });
	await producerClient.sendBatch(eventDataBatch);
	return producerClient.close();
}
