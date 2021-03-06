﻿using System;
using System.Threading.Tasks;
using ProGaudi.Tarantool.Client.Model;

namespace ProGaudi.Tarantool.Client
{
    public interface INetworkStreamPhysicalConnection : IDisposable
    {
        Task Connect(ClientOptions options);
        Task Flush();
        bool IsConnected();
        Task<int> ReadAsync(byte[] buffer, int offset, int count);
        void Write(byte[] buffer, int offset, int count);
    }
}