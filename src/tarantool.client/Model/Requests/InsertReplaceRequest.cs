﻿using ProGaudi.Tarantool.Client.Model.Enums;

namespace ProGaudi.Tarantool.Client.Model.Requests
{
    public abstract class InsertReplaceRequest<T> : IRequest
        where T : ITarantoolTuple
    {
        protected InsertReplaceRequest(CommandCode code, uint spaceId, T tuple)
        {
            Code = code;
            SpaceId = spaceId;
            Tuple = tuple;
        }

        public uint SpaceId { get; }

        public T Tuple { get; }

        public CommandCode Code { get; }
    }
}