extension Task where Failure == Error {
    public var cancellableValue: Success {
        get async throws {
            try await withTaskCancellationHandler {
                try await self.value
            } onCancel: {
                self.cancel()
            }
        }
    }
}

extension Task where Failure == Never {
    public var cancellableValue: Success {
        get async {
            await withTaskCancellationHandler {
                await self.value
            } onCancel: {
                self.cancel()
            }
        }
    }
}
