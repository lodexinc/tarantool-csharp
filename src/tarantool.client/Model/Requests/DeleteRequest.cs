﻿using ProGaudi.Tarantool.Client.Model.Enums;

namespace ProGaudi.Tarantool.Client.Model.Requests
{
    public class DeleteRequest<T> : IRequest
        where T : ITarantoolTuple
    {
        public DeleteRequest(uint spaceId, uint indexId, T key)
        {
            SpaceId = spaceId;
            IndexId = indexId;
            Key = key;
        }

        public uint SpaceId { get; }

        public uint IndexId { get; }

        public T Key { get; }

        public CommandCode Code => CommandCode.Delete;
    }
}