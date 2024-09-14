import { ScreenshareService } from "@/bar/omnibar/screenshare/screenshare-service";
import { expect, test } from "vitest";
import { readFileSync } from "node:fs"


const symStart = (service: ScreenshareService) => {
    const file = readFileSync(`${__dirname}/fixtures/screenshare-start.txt`).toString("utf-8");
    for (const line of file.split("\n")) {
        service.parseLine(line);
    }
}

test("should show charging when under percent", () => {
    const service = new ScreenshareService();
    symStart(service)
    service.debugDump()
    expect(service.getRunning()).toContain({
        id: "237"
    })
});
